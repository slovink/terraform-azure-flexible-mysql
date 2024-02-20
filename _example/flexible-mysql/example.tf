provider "azurerm" {
  features {}
}

locals {
  name        = "app"
  environment = "test"
  # label_order = ["name", "environment"]
}


module "resource_group" {
  source      = "git@github.com:slovink/terraform-azure-resource-group.git?ref=1.0.0"
  name        = "app"
  environment = "tested"
  location    = "North Europe"
}


module "vnet" {
  source              = "git@github.com:slovink/terraform-azure-vnet.git?ref=1.0.0"
  name                = "app"
  environment         = "test"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = "10.0.0.0/16"
}


module "subnet" {
  source = "git@github.com:slovink/terraform-azure-subnet.git?ref=1.0.0"

  name                 = "app"
  environment          = "test"
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.name

  #subnet
  subnet_names    = ["subnet1"]
  subnet_prefixes = ["10.0.1.0/24"]

  service_endpoints = ["Microsoft.Storage"]
  delegation = {
    flexibleServers_delegation = [
      {
        name    = "Microsoft.DBforMySQL/flexibleServers"
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      }
    ]
  }
  # route_table
  enable_route_table = true
  route_table_name   = "default_subnet"
  routes = [
    {
      name           = "rt-test"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}


module "flexible-mysql" {
  depends_on          = [module.resource_group, module.vnet]
  source              = "../../"
  name                = local.name
  environment         = local.environment
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  virtual_network_id  = module.vnet.id
  delegated_subnet_id = [module.subnet.default_subnet_id][0]
  mysql_version       = "8.0.21"
  private_dns         = true
  zone                = "1"
  admin_username      = "mysqlusername"
  admin_password      = "ba5yatgfgfhdsv6A3ns2lu4gqzzc"
  sku_name            = "GP_Standard_D8ds_v4"
  db_name             = "maindb"
  charset             = "utf8mb3"
  collation           = "utf8mb3_unicode_ci"
  auto_grow_enabled   = true
  iops                = 360
  size_gb             = "20"
  #azurerm_mysql_flexible_server_configuration
  server_configuration_names = ["interactive_timeout", "audit_log_enabled"]
  values                     = ["600", "ON"]
}
