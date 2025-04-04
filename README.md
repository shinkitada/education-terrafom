# Terraform AWS Education Project

## 概要
このプロジェクトは、Terraformを使用してAWSリソースを構築する教育用のサンプルです。  
以下のリソースを作成します：
- VPC
- サブネット
- インターネットゲートウェイ
- ルートテーブルとその関連付け
- EC2インスタンス
- セキュリティグループ
- SSHキーの生成

## フォルダ構成
```
.
├── .gitignore                # Gitで無視するファイルの設定
├── .terraform.lock.hcl       # Terraformのプロバイダーのロックファイル
├── ec2.tf                    # EC2インスタンスと関連リソースの定義
├── provider.tf               # プロバイダーの設定
├── terraform.tfstate         # Terraformの状態ファイル（自動生成）
├── terraform.tfstate.backup  # Terraformの状態ファイルのバックアップ（自動生成）
├── terraform.tfvars.example  # 変数の例ファイル
├── variables.tf              # 変数の定義
├── vpc.tf                    # VPCとネットワーク関連リソースの定義
└── .terraform/               # Terraformのキャッシュディレクトリ（自動生成）
```

## 必要条件
- Terraform 1.0以上
- AWSアカウント
- AWS CLIが設定済みであること

## 使用方法

### 1. リポジトリをクローン
```bash
git clone https://github.com/your-repo/terraform-aws-education.git
cd terraform-aws-education
```

### 2. 変数ファイルを作成
`terraform.tfvars.example` をコピーして `terraform.tfvars` を作成し、必要な値を設定します。
```bash
cp terraform.tfvars.example terraform.tfvars
```

### 3. Terraformの初期化
Terraformのプロバイダーをインストールします。
```bash
terraform init
```

### 4. 設定の確認
作成されるリソースを確認します。
```bash
terraform plan
```

### 5. リソースの作成
AWS上にリソースを作成します。
```bash
terraform apply
```

### 6. リソースの削除
作成したリソースを削除する場合は以下を実行します。
```bash
terraform destroy
```

## 主なファイルの説明

### `vpc.tf`
- VPC、サブネット、インターネットゲートウェイ、ルートテーブルを定義しています。

### `ec2.tf`
- EC2インスタンス、SSHキー、セキュリティグループを定義しています。
- `http`プロバイダーを使用して現在のIPアドレスを取得し、SSHアクセスを制限しています。

### `variables.tf`
- リージョン、名前、環境名などの変数を定義しています。

### `provider.tf`
- AWSプロバイダーとHTTPプロバイダーの設定を行っています。

## 注意事項
- `.tfvars` ファイルには機密情報が含まれる可能性があるため、`.gitignore` に追加されています。
- 実行前にAWSアカウントの料金体系を確認してください。

## ライセンス
このプロジェクトはMITライセンスのもとで公開されています。

## 貢献
バグ報告や機能提案は歓迎します！プルリクエストを送る際は、事前にIssueを作成してください。
