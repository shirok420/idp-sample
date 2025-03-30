# Keycloakレルムの取得
data "keycloak_realm" "realm" {
  realm = var.realm_name
}

# OAuthクライアントの作成
resource "keycloak_openid_client" "oauth_clients" {
  for_each = { for client in var.oauth_clients : client.client_id => client }

  realm_id                     = data.keycloak_realm.realm.id
  client_id                    = each.value.client_id
  name                         = each.value.name
  description                  = each.value.description
  enabled                      = each.value.enabled
  standard_flow_enabled        = each.value.standard_flow_enabled
  implicit_flow_enabled        = each.value.implicit_flow_enabled
  direct_access_grants_enabled = each.value.direct_access_grants_enabled
  service_accounts_enabled     = each.value.service_accounts_enabled
  valid_redirect_uris          = each.value.valid_redirect_uris
  web_origins                  = each.value.web_origins
  admin_url                    = each.value.admin_url
  base_url                     = each.value.base_url
  root_url                     = each.value.root_url
  access_type                  = each.value.access_type
  client_secret                = each.value.client_secret
  client_authenticator_type    = each.value.client_authenticator_type
  full_scope_allowed           = each.value.full_scope_allowed
  consent_required             = each.value.consent_required
}

# クライアントロールの作成
resource "keycloak_role" "client_roles" {
  for_each = {
    for role in flatten([
      for client_id, roles in var.client_roles : [
        for role in roles : {
          key           = "${client_id}:${role.name}"
          client_id     = client_id
          name          = role.name
          description   = role.description
        }
      ]
    ]) : role.key => role
  }

  realm_id    = data.keycloak_realm.realm.id
  client_id   = keycloak_openid_client.oauth_clients[each.value.client_id].id
  name        = each.value.name
  description = each.value.description
}

# クライアントスコープの割り当て
resource "keycloak_openid_client_default_scopes" "client_scopes" {
  for_each = var.client_scopes

  realm_id  = data.keycloak_realm.realm.id
  client_id = keycloak_openid_client.oauth_clients[each.key].id
  default_scopes = each.value
}

# サービスアカウントロールの割り当て
resource "keycloak_openid_client_service_account_role" "service_account_roles" {
  for_each = {
    for role in flatten([
      for client_id, roles in var.service_account_roles : [
        for role in roles : {
          key           = "${client_id}:${role.client_id}:${role.role_name}"
          client_id     = client_id
          role_client_id = role.client_id
          role_name     = role.role_name
        }
      ]
    ]) : role.key => role
  }

  realm_id                = data.keycloak_realm.realm.id
  service_account_user_id = keycloak_openid_client.oauth_clients[each.value.client_id].service_account_user_id
  client_id               = each.value.role_client_id
  role                    = each.value.role_name
}

# プロトコルマッパーの設定
resource "keycloak_openid_user_attribute_protocol_mapper" "user_attribute_mappers" {
  for_each = {
    for client in var.oauth_clients : client.client_id => client
    if client.service_accounts_enabled
  }

  realm_id    = data.keycloak_realm.realm.id
  client_id   = keycloak_openid_client.oauth_clients[each.key].id
  name        = "service-account-id"
  user_attribute = "serviceAccountClientId"
  claim_name  = "clientId"
  claim_value_type = "String"
  add_to_id_token = true
  add_to_access_token = true
  add_to_userinfo = true
}

# クライアントシークレットの更新（必要な場合）
resource "keycloak_openid_client" "update_client_secret" {
  for_each = {
    for client in var.oauth_clients : client.client_id => client
    if client.client_secret != null && client.access_type == "CONFIDENTIAL"
  }

  realm_id      = data.keycloak_realm.realm.id
  client_id     = each.value.client_id
  client_secret = each.value.client_secret

  # 他の属性はkeycloak_openid_clientリソースから継承
  name                         = keycloak_openid_client.oauth_clients[each.key].name
  enabled                      = keycloak_openid_client.oauth_clients[each.key].enabled
  standard_flow_enabled        = keycloak_openid_client.oauth_clients[each.key].standard_flow_enabled
  implicit_flow_enabled        = keycloak_openid_client.oauth_clients[each.key].implicit_flow_enabled
  direct_access_grants_enabled = keycloak_openid_client.oauth_clients[each.key].direct_access_grants_enabled
  service_accounts_enabled     = keycloak_openid_client.oauth_clients[each.key].service_accounts_enabled
  valid_redirect_uris          = keycloak_openid_client.oauth_clients[each.key].valid_redirect_uris
  web_origins                  = keycloak_openid_client.oauth_clients[each.key].web_origins
  access_type                  = keycloak_openid_client.oauth_clients[each.key].access_type
  client_authenticator_type    = keycloak_openid_client.oauth_clients[each.key].client_authenticator_type
  full_scope_allowed           = keycloak_openid_client.oauth_clients[each.key].full_scope_allowed
  consent_required             = keycloak_openid_client.oauth_clients[each.key].consent_required

  depends_on = [keycloak_openid_client.oauth_clients]
}