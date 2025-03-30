variable "keycloak_url" {
  description = "KeycloakサーバーのベースURL"
  type        = string
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
}

variable "keycloak_password" {
  description = "Keycloak管理者パスワード"
  type        = string
  sensitive   = true
}

variable "realm_name" {
  description = "管理対象のKeycloakレルム名"
  type        = string
  default     = "idp"
}

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
  default = []
}

variable "client_roles" {
  description = "クライアントごとのロール定義"
  type = map(list(object({
    name        = string
    description = optional(string, "")
  })))
  default = {}
}

variable "client_scopes" {
  description = "クライアントごとのスコープ定義"
  type = map(list(string))
  default = {}
}

variable "service_account_roles" {
  description = "サービスアカウントに割り当てるロール"
  type = map(list(object({
    client_id = string
    role_name = string
  })))
  default = {}
}