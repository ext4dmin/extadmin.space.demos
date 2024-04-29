locals {
  current_date = timestamp()
  expiry_date  = timeadd(timestamp(), "8760h")
}

variable "rg_name" {
  type = string
}
variable "location" {
  default = "westeurope"
}
variable "sa_name" {
  type = string
}
variable "sa_tier" {
  default = "Standard"
}
variable "sa_repl" {
  default = "LRS"
}
variable "kv_name" {
  type = string
}
variable "kv_sku" {
  default = "standard"
}
variable "pg_flex_serv_name" {
  type        = string
  description = "Insert server's postfix"
}
variable "pg_admin" {
  default = "pgadmin"
}
variable "pg_pass" {
  sensitive = true
  type      = string
}
variable "pg_sku" {
  default = "B_Standard_B1ms"
}
variable "pg_storage_tier" {
  default = "P4"
}