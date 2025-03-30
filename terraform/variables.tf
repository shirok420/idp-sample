# Keycloak接続設定
variable "keycloak_url" {
  description = "KeycloakサーバーのベースURL"
  type        = string
  default     = "http://localhost:8080"
}

variable "keycloak_client_id" {
  description = "Keycloak管理APIにアクセスするためのクライアントID"
  type        = string
  default     = "admin-cli"
}

variable "keycloak_client_secret" {
  description = "Keycloak管理APIにアクセスするためのクライアントシークレット"
  type        = string
  default     = ""
}

variable "keycloak_user" {
  description = "Keycloak管理者ユーザー名"
  type        = string
  default     = "admin"
}

variable "keycloak_password" {
  description = "Keycloak管理者パスワード"
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "realm_name" {
  description = "管理対象のKeycloakレルム名"
  type        = string
  default     = "idp"
}

# 環境ごとの設定
variable "environments" {
  description = "環境ごとのKeycloak設定"
  type = object({
    dev = object({
      keycloak_url      = string
      keycloak_user     = string
      keycloak_password = string
    })
    staging = object({
      keycloak_url      = string
      keycloak_user     = string
      keycloak_password = string
    })
    production = object({
      keycloak_url      = string
      keycloak_user     = string
      keycloak_password = string
    })
  })
  default = {
    dev = {
      keycloak_url      = "http://localhost:8080"
      keycloak_user     = "admin"
      keycloak_password = "admin"
    }
    staging = {
      keycloak_url      = "https://keycloak-staging.example.com"
      keycloak_user     = "admin"
      keycloak_password = "admin"
    }
    production = {
      keycloak_url      = "https://keycloak.example.com"
      keycloak_user     = "admin"
      keycloak_password = "admin"
    }
  }
  sensitive = true
}

# 環境の選択
variable "environment" {
  description = "現在の環境（dev, staging, production）"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "環境は 'dev', 'staging', 'production' のいずれかである必要があります。"
  }
}

# OAuthクライアント設定
variable "oauth_clients" {
  description = "作成・管理するOAuthクライアントのリスト"
  type = list(object({
    client_id                  = string
    name                       = string
    description                = optional(string, "")
    enabled                    = optional(bool, true)
    standard_flow_enabled      = optional(bool, true)
    implicit_flow_enabled      = optional(bool, false)
    direct_access_grants_enabled = optional(bool, true)
    service_accounts_enabled   = optional(bool, false)
    valid_redirect_uris        = optional(list(string), [])
    web_origins                = optional(list(string), [])
    admin_url                  = optional(string, "")
    base_url                   = optional(string, "")
    root_url                   = optional(string, "")
    access_type                = optional(string, "CONFIDENTIAL") # CONFIDENTIAL, PUBLIC, BEARER-ONLY
    client_secret              = optional(string, null)
    client_authenticator_type  = optional(string, "client-secret")
    full_scope_allowed         = optional(bool, true)
    consent_required           = optional(bool, false)
  }))
  default = [
    {
      client_id             = "kong-gateway"
      name                  = "Kong API Gateway"
      description           = "Kong API Gatewayとの連携用クライアント"
      enabled               = true
      service_accounts_enabled = true
      valid_redirect_uris   = ["http://localhost:8000/*"]
      web_origins           = ["http://localhost:8000"]
      access_type           = "CONFIDENTIAL"
      client_secret         = "kong-client-secret"
    },
    {
      client_id             = "frontend-app"
      name                  = "フロントエンドアプリケーション"
      description           = "ユーザー向けWebアプリケーション"
      enabled               = true
      standard_flow_enabled = true
      valid_redirect_uris   = ["http://localhost:3000/*"]
      web_origins           = ["http://localhost:3000"]
      access_type           = "PUBLIC"
    }
  ]
}

# クライアントロール設定
variable "client_roles" {
  description = "クライアントごとのロール定義"
  type = map(list(object({
    name        = string
    description = optional(string, "")
  })))
  default = {
    "kong-gateway" = [
      {
        name        = "admin"
        description = "Kong管理者ロール"
      },
      {
        name        = "user"
        description = "Kong一般ユーザーロール"
      }
    ],
    "frontend-app" = [
      {
        name        = "user"
        description = "アプリケーション一般ユーザーロール"
      },
      {
        name        = "admin"
        description = "アプリケーション管理者ロール"
      }
    ]
  }
}

# クライアントスコープ設定
variable "client_scopes" {
  description = "クライアントごとのスコープ定義"
  type = map(list(string))
  default = {
    "kong-gateway" = ["profile", "email", "roles"]
    "frontend-app" = ["profile", "email", "roles", "offline_access"]
  }
}

# サービスアカウントロール設定
variable "service_account_roles" {
  description = "サービスアカウントに割り当てるロール"
  type = map(list(object({
    client_id = string
    role_name = string
  })))
  default = {
    "kong-gateway" = [
      {
        client_id = "realm-management"
        role_name = "view-users"
      },
      {
        client_id = "realm-management"
        role_name = "view-clients"
      }
    ]
  }
}