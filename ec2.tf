#httpプロバイダーを使用してmyipのURLを取得する
data "http" "my_ip" {
  url = "https://api.ipify.org?format=json"
}

#ローカル変数
locals {
  public_key_file  = "./.key/${var.name}-key.id_rsa.pub"
  private_key_file = "./.key/${var.name}-key.id_rsa"
  my_ip            = "${jsondecode(data.http.my_ip.response_body)["ip"]}/32"
}

#秘密鍵の作成
resource "tls_private_key" "keygen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_pem" {
  filename = local.private_key_file
  content  = tls_private_key.keygen.private_key_pem
  provisioner "local-exec" {
    command = "chmod 600 ${local.private_key_file}"
  }
}

resource "local_file" "public_key_pem" {
  filename = local.public_key_file
  content  = tls_private_key.keygen.public_key_pem
  provisioner "local-exec" {
    command = "chmod 600 ${local.public_key_file}"
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.name}-key"
  public_key = tls_private_key.keygen.public_key_openssh
}

# SSH用のセキュリティグループを作成
resource "aws_security_group" "allow_ssh" {
  name        = "${var.name}-allow-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]
  }
}

variable "ami_id" {
  description = "The AMI ID for the instance"
  type        = string
  default     = "ami-03ec4a957caaadb88"
}

#インスタンス作成
resource "aws_instance" "my_instance" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.key_pair.key_name
  subnet_id            = aws_subnet.my_subnet_1a.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "terraform-edu-${var.name}-instance"
  }
}