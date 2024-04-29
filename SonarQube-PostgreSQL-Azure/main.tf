### Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

### Create Starage account
resource "azurerm_storage_account" "sa" {
  depends_on               = [azurerm_resource_group.rg]
  name                     = var.sa_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = var.sa_tier
  account_replication_type = var.sa_repl
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_share" "fs_sonarqubedata" {
  depends_on           = [azurerm_storage_account.sa]
  name                 = "sonarqubedata"
  storage_account_name = azurerm_storage_account.sa.name
  quota                = 2
  access_tier          = "Hot"
}
resource "azurerm_storage_share" "fs_sonarqubeextensions" {
  depends_on           = [azurerm_storage_account.sa]
  name                 = "sonarqubeextensions"
  storage_account_name = azurerm_storage_account.sa.name
  quota                = 1
  access_tier          = "Hot"
}
resource "azurerm_storage_share" "fs_sonarqubelogs" {
  depends_on           = [azurerm_storage_account.sa]
  name                 = "sonarqubelogs"
  storage_account_name = azurerm_storage_account.sa.name
  quota                = 1
  access_tier          = "Hot"
}

### Create LogAnalitycs Workspace
resource "azurerm_log_analytics_workspace" "la_ws" {
  name                = "LogAnalyticsWS"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

### Create Key Vault and assign Get permission to Func MI
resource "azurerm_key_vault" "key_vault" {
  depends_on = [azurerm_storage_account.sa,
  azurerm_log_analytics_workspace.la_ws]
  name                       = var.kv_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.kv_sku
  soft_delete_retention_days = 7

}

resource "azurerm_key_vault_access_policy" "kv_policy-01" {
  depends_on   = [azurerm_key_vault.key_vault]
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "List",
    "Get",
    "Set",
    "Delete",
    "Purge"
  ]
}

### Create Secrets

resource "azurerm_key_vault_secret" "key_vaultsecret-sa-ak" {
  depends_on   = [azurerm_key_vault_access_policy.kv_policy-01]
  name         = "sa-access-key"
  value        = azurerm_storage_account.sa.primary_access_key
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "key_vaultsecret-la-ws" {
  depends_on   = [azurerm_key_vault_access_policy.kv_policy-01]
  name         = "la-workspace-key"
  value        = azurerm_log_analytics_workspace.la_ws.primary_shared_key
  key_vault_id = azurerm_key_vault.key_vault.id
}

### Create Flexible Postgre DB
resource "azurerm_postgresql_flexible_server" "pg_flex_serv" {
  name                = "pgserver-${var.pg_flex_serv_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "North Europe" #var.location
  version             = "12"
  # delegated_subnet_id    = azurerm_subnet.subnet-db.id
  # private_dns_zone_id    = azurerm_private_dns_zone.dns.id
  administrator_login    = var.pg_admin
  administrator_password = var.pg_pass
  zone                   = 1


  storage_mb   = 32768
  storage_tier = var.pg_storage_tier

  sku_name   = var.pg_sku
  depends_on = [azurerm_resource_group.rg]

}

resource "azurerm_postgresql_flexible_server_database" "default" {
  name      = "sonar"
  server_id = azurerm_postgresql_flexible_server.pg_flex_serv.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}


resource "azurerm_postgresql_flexible_server_firewall_rule" "example" {
  name             = "Azure-services"
  server_id        = azurerm_postgresql_flexible_server.pg_flex_serv.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}