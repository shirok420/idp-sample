# クライアントIDとクライアントシークレットのマップを出力
output "client_secrets" {
  description = "作成されたOAuthクライアントのIDとシークレットのマップ"
  value = {
    for client_id, client in keycloak_openid_client.oauth_clients :
    client_id => {
      id     = client.id
      secret = client.client_secret
    }
  }
  sensitive = true
}

# クライアントの詳細情報を出力
output "clients" {
  description = "作成されたOAuthクライアントの詳細情報"
  value = {
    for client_id, client in keycloak_openid_client.oauth_clients :
    client_id => {
      id                    = client.id
      name                  = client.name
      enabled               = client.enabled
      service_account_user_id = client.service_accounts_enabled ? client.service_account_user_id : null
      redirect_uris         = client.valid_redirect_uris
      web_origins           = client.web_origins
      access_type           = client.access_type
    }
  }
}

# クライアントロールの情報を出力
output "client_roles" {
  description = "作成されたクライアントロールの情報"
  value = {
    for role_key, role in keycloak_role.client_roles :
    role_key => {
      id          = role.id
      name        = role.name
      description = role.description
    }
  }
}

# レルム情報を出力
output "realm" {
  description = "使用されたKeycloakレルムの情報"
  value = {
    id   = data.keycloak_realm.realm.id
    name = data.keycloak_realm.realm.realm
  }
}