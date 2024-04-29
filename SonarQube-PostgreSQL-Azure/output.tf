output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "loganalitycs_ws_id" {
  value = azurerm_log_analytics_workspace.la_ws.workspace_id
}
output "loganalitycs_ws_resid" {
  value = azurerm_log_analytics_workspace.la_ws.id
}
output "loganalitycs_ws_key" {
  value = azurerm_log_analytics_workspace.la_ws.primary_shared_key
  sensitive = true
}
output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}
output "storage_account_key" {
  value = azurerm_storage_account.sa.primary_access_key
  sensitive = true
}
output "pg_flex_serv_fqdn" {
  value = azurerm_postgresql_flexible_server.pg_flex_serv.fqdn
}
output "pg_user_name" {
  value = azurerm_postgresql_flexible_server.pg_flex_serv.administrator_login
}
output "pg_admin_pass" {
  value = azurerm_postgresql_flexible_server.pg_flex_serv.administrator_password
  sensitive = true
}
output "db_name" {
  value = azurerm_postgresql_flexible_server_database.default.name
}