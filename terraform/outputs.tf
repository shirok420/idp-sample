# 現在の環境のクライアントシークレット情報を出力
output "client_secrets" {
  description = "現在の環境で作成されたOAuthクライアントのIDとシークレットのマップ"
  value       = local.current_output.client_secrets
  sensitive   = true
}

# 現在の環境のクライアント情報を出力
output "clients" {
  description = "現在の環境で作成されたOAuthクライアントの詳細情報"
  value       = local.current_output.clients
}

# 現在の環境のクライアントロール情報を出力
output "client_roles" {
  description = "現在の環境で作成されたクライアントロールの情報"
  value       = local.current_output.client_roles
}

# 現在の環境のレルム情報を出力
output "realm" {
  description = "現在の環境で使用されたKeycloakレルムの情報"
  value       = local.current_output.realm
}

# 現在の環境名を出力
output "environment" {
  description = "現在の環境名"
  value       = var.environment
}

# Keycloak URLを出力
output "keycloak_url" {
  description = "現在の環境のKeycloak URL"
  value       = var.environments[var.environment].keycloak_url
}