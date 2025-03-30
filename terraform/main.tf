# 環境に基づいてKeycloakプロバイダーを選択
locals {
  keycloak_provider = {
    dev        = keycloak.dev
    staging    = keycloak.staging
    production = keycloak.production
  }
  current_provider = local.keycloak_provider[var.environment]
}

# 開発環境のKeycloakクライアント設定
module "keycloak_dev" {
  source = "./modules/keycloak"
  count  = var.environment == "dev" ? 1 : 0

  providers = {
    keycloak = keycloak.dev
  }

  keycloak_url         = var.environments.dev.keycloak_url
  keycloak_user        = var.environments.dev.keycloak_user
  keycloak_password    = var.environments.dev.keycloak_password
  keycloak_client_id   = var.keycloak_client_id
  keycloak_client_secret = var.keycloak_client_secret
  realm_name           = var.realm_name
  oauth_clients        = var.oauth_clients
  client_roles         = var.client_roles
  client_scopes        = var.client_scopes
  service_account_roles = var.service_account_roles
}

# ステージング環境のKeycloakクライアント設定
module "keycloak_staging" {
  source = "./modules/keycloak"
  count  = var.environment == "staging" ? 1 : 0

  providers = {
    keycloak = keycloak.staging
  }

  keycloak_url         = var.environments.staging.keycloak_url
  keycloak_user        = var.environments.staging.keycloak_user
  keycloak_password    = var.environments.staging.keycloak_password
  keycloak_client_id   = var.keycloak_client_id
  keycloak_client_secret = var.keycloak_client_secret
  realm_name           = var.realm_name
  oauth_clients        = var.oauth_clients
  client_roles         = var.client_roles
  client_scopes        = var.client_scopes
  service_account_roles = var.service_account_roles
}

# 本番環境のKeycloakクライアント設定
module "keycloak_production" {
  source = "./modules/keycloak"
  count  = var.environment == "production" ? 1 : 0

  providers = {
    keycloak = keycloak.production
  }

  keycloak_url         = var.environments.production.keycloak_url
  keycloak_user        = var.environments.production.keycloak_user
  keycloak_password    = var.environments.production.keycloak_password
  keycloak_client_id   = var.keycloak_client_id
  keycloak_client_secret = var.keycloak_client_secret
  realm_name           = var.realm_name
  oauth_clients        = var.oauth_clients
  client_roles         = var.client_roles
  client_scopes        = var.client_scopes
  service_account_roles = var.service_account_roles
}

# 環境ごとの設定を条件付きで出力
locals {
  keycloak_output = {
    dev        = var.environment == "dev" ? module.keycloak_dev[0] : null
    staging    = var.environment == "staging" ? module.keycloak_staging[0] : null
    production = var.environment == "production" ? module.keycloak_production[0] : null
  }
  current_output = local.keycloak_output[var.environment]
}