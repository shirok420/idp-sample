# Terraform GitOpsによるKeycloak OAuthClient管理

このドキュメントでは、TerraformとGitHub Actionsを使用してKeycloakのOAuthClient設定をGitOpsによって管理する方法について説明します。

## 概要

このプロジェクトでは、以下の技術を使用してKeycloakのOAuthClient設定を管理しています：

- **Terraform**: インフラストラクチャをコードとして管理するためのツール
- **Keycloak Provider**: Terraformから Keycloak リソースを管理するためのプロバイダー
- **GitHub Actions**: CI/CDパイプラインを自動化するためのツール
- **GitOps**: Gitリポジトリをシングルソースオブトゥルースとして使用する運用モデル

## ディレクトリ構造

```
terraform/
  ├── main.tf         # メインのTerraform設定
  ├── variables.tf    # 変数定義
  ├── outputs.tf      # 出力定義
  ├── providers.tf    # プロバイダー設定
  └── modules/
      └── keycloak/   # Keycloakモジュール
          ├── main.tf         # モジュールのメイン設定
          ├── variables.tf    # モジュール変数
          └── outputs.tf      # モジュール出力

.github/
  └── workflows/
      └── terraform.yml  # GitHub Actionsワークフロー
```

## ローカルでのTerraformの使用方法

### 前提条件

- Terraform CLI (バージョン 1.0.0以上)
- Keycloakサーバーへのアクセス

### 初期化

```bash
cd terraform
terraform init
```

### 計画

```bash
# 開発環境
terraform plan -var="environment=dev"

# ステージング環境
terraform plan -var="environment=staging"

# 本番環境
terraform plan -var="environment=production"
```

### 適用

```bash
# 開発環境
terraform apply -var="environment=dev"

# ステージング環境
terraform apply -var="environment=staging"

# 本番環境
terraform apply -var="environment=production"
```

## GitOpsワークフローの使用方法

### 自動デプロイ

1. `terraform/` ディレクトリ内のファイルを変更します
2. 変更をコミットし、`main` ブランチにプッシュします
3. GitHub Actionsが自動的にTerraformを実行し、変更を適用します

### プルリクエストによるレビュー

1. 新しいブランチを作成します
2. `terraform/` ディレクトリ内のファイルを変更します
3. 変更をコミットし、プルリクエストを作成します
4. GitHub Actionsが自動的にTerraformプランを実行し、結果をPRにコメントします
5. レビュー後、PRをマージすると変更が適用されます

### 手動デプロイ

1. GitHub Actionsの「Terraform GitOps」ワークフローを手動で実行します
2. 環境（dev/staging/production）を選択します
3. ワークフローが実行され、選択した環境に変更が適用されます

## OAuthクライアントの追加方法

新しいOAuthクライアントを追加するには、`terraform/variables.tf` ファイルの `oauth_clients` 変数に新しいクライアント設定を追加します：

```hcl
variable "oauth_clients" {
  # ...
  default = [
    # 既存のクライアント
    {
      client_id             = "existing-client"
      # ...
    },
    # 新しいクライアント
    {
      client_id             = "new-client"
      name                  = "新しいクライアント"
      description           = "新しいクライアントの説明"
      enabled               = true
      standard_flow_enabled = true
      valid_redirect_uris   = ["http://localhost:3000/*"]
      web_origins           = ["http://localhost:3000"]
      access_type           = "PUBLIC"
    }
  ]
}
```

## クライアントロールの追加方法

新しいクライアントロールを追加するには、`terraform/variables.tf` ファイルの `client_roles` 変数に新しいロール設定を追加します：

```hcl
variable "client_roles" {
  # ...
  default = {
    # 既存のクライアントロール
    "existing-client" = [
      # ...
    ],
    # 新しいクライアントロール
    "new-client" = [
      {
        name        = "user"
        description = "一般ユーザーロール"
      },
      {
        name        = "admin"
        description = "管理者ロール"
      }
    ]
  }
}
```

## 環境ごとの設定

環境ごとに異なる設定を使用するには、`terraform/variables.tf` ファイルの `environments` 変数を編集します：

```hcl
variable "environments" {
  # ...
  default = {
    dev = {
      keycloak_url      = "http://localhost:8080"
      keycloak_user     = "admin"
      keycloak_password = "admin"
    },
    staging = {
      keycloak_url      = "https://keycloak-staging.example.com"
      keycloak_user     = "admin"
      keycloak_password = "admin"
    },
    production = {
      keycloak_url      = "https://keycloak.example.com"
      keycloak_user     = "admin"
      keycloak_password = "admin"
    }
  }
}
```

## シークレット管理

GitHub Actionsで使用するシークレットは、GitHubリポジトリの「Settings」→「Secrets and variables」→「Actions」で設定します。

以下のシークレットを設定する必要があります：

- `KEYCLOAK_USER`: Keycloak管理者ユーザー名
- `KEYCLOAK_PASSWORD`: Keycloak管理者パスワード
- `TF_API_TOKEN`: Terraform Cloudのトークン（Terraform Cloudを使用する場合）
- `SLACK_WEBHOOK`: Slack通知用のWebhook URL（オプション）

## トラブルシューティング

### Terraformの実行に失敗する場合

1. Keycloakサーバーが起動していることを確認します
2. Keycloakの認証情報が正しいことを確認します
3. Terraformの状態ファイルをリセットする必要がある場合は、`terraform/terraform.tfstate` ファイルを削除し、再度初期化します

### GitHub Actionsの実行に失敗する場合

1. GitHub Secretsが正しく設定されていることを確認します
2. ワークフローのログを確認して、エラーの詳細を確認します
3. 必要に応じて、手動でTerraformを実行して問題を特定します