terraform {
  required_version = ">= 1.0.0"

  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "~> 4.3.0"
    }
  }

  # バックエンドの設定（GitOps用）
  # 本番環境ではS3やGCSなどのリモートバックエンドを使用することを推奨
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Keycloakプロバイダーの設定
provider "keycloak" {
  client_id     = var.keycloak_client_id
  client_secret = var.keycloak_client_secret
  url           = var.keycloak_url
  username      = var.keycloak_user
  password      = var.keycloak_password
}

# 環境ごとの設定を切り替えるための条件付きプロバイダー設定
provider "keycloak" {
  alias         = "dev"
  client_id     = var.keycloak_client_id
  client_secret = var.keycloak_client_secret
  url           = var.environments.dev.keycloak_url
  username      = var.environments.dev.keycloak_user
  password      = var.environments.dev.keycloak_password
}

provider "keycloak" {
  alias         = "staging"
  client_id     = var.keycloak_client_id
  client_secret = var.keycloak_client_secret
  url           = var.environments.staging.keycloak_url
  username      = var.environments.staging.keycloak_user
  password      = var.environments.staging.keycloak_password
}

provider "keycloak" {
  alias         = "production"
  client_id     = var.keycloak_client_id
  client_secret = var.keycloak_client_secret
  url           = var.environments.production.keycloak_url
  username      = var.environments.production.keycloak_user
  password      = var.environments.production.keycloak_password
}