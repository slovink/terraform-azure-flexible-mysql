 <p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>


<h1 align="center">
    Terraform Azure Flexible Mysql
</h1>

<p align="center" style="font-size: 1.2rem;">
    Terraform module to create Azure flexible mysql service resource on AZURE.
     </p>

<p align="center">

<a href="https://www.terraform.io">
  <img src="https://img.shields.io/badge/Terraform-v1.7.4-green" alt="Terraform">
</a>
<a href="https://github.com/slovink/terraform-azure-flexible-mysql/blob/master/LICENSE">
  <img src="https://img.shields.io/badge/License-APACHE-blue.svg" alt="Licence">
</a>

# Terraform Azure Infrastructure

This Terraform configuration defines an Azure infrastructure using the Azure provider.

## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [Examples](#examples)
- [License](#license)

## Introduction
This repository contains Terraform code to deploy resources on Microsoft Azure, including a resource group and a virtual network and flexible-mysql.

## Usage
To use this module, you should have Terraform installed and configured for AZURE. This module provides the necessary Terraform configuration
for creating AZURE resources, and you can customize the inputs as needed. Below is an example of how to use this module:

# Examples

# Example: flexible-mysql

```hcl
module "flexible-mysql" {
  depends_on          = [module.resource_group, module.vnet]
  source              = "https://github.com/slovink/terraform-azure-flexible-mysql.git?ref=1.0.0"
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
```
# Example: flexible-mysql-replication

```hcl
module "flexible-mysql-replication" {
  depends_on                     = [module.resource_group, module.vnet, data.azurerm_resource_group.main]
  source                         = "https://github.com/slovink/terraform-azure-flexible-mysql.git?ref=1.0.0"
  name                           = local.name
  environment                    = local.environment
  main_rg_name                   = data.azurerm_resource_group.main.name
  resource_group_name            = module.resource_group.resource_group_name
  location                       = module.resource_group.resource_group_location
  virtual_network_id             = module.vnet.id
  delegated_subnet_id            = [module.subnet.default_subnet_id][0]
  mysql_version                  = "8.0.21"
  zone                           = "1"
  admin_username                 = "mysqlusern"
  admin_password                 = "ba5yatgfgfhdsvvc6A3ns2lu4gqzzc"
  sku_name                       = "GP_Standard_D8ds_v4"
  db_name                        = "maindb"
  charset                        = "utf8"
  collation                      = "utf8_unicode_ci"
  auto_grow_enabled              = true
  iops                           = 360
  size_gb                        = "20"
  existing_private_dns_zone      = true
  existing_private_dns_zone_id   = data.azurerm_private_dns_zone.main.id
  existing_private_dns_zone_name = data.azurerm_private_dns_zone.main.name
  ##azurerm_mysql_flexible_server_configuration
  server_configuration_names = ["interactive_timeout", "audit_log_enabled"]
  values                     = ["600", "ON"]
}
```
This example demonstrates how to create various AZURE resources using the provided modules. Adjust the input values to suit your specific requirements.

## Module Inputs
The following input variables can be configured:

- 'name': The name which should be used for this MySQL Flexible Server.
- 'resource_group_name': The name of the Resource Group where the MySQL Flexible Server should exist.
- 'admin_username': The Administrator login for the MySQL Flexible Server.
- 'admin_password ': The Password associated with the administrator_login for the MySQL Flexible Server.
- 'db_name': Specifies the name of the MySQL Database,
- 'mysql_version': The version of the MySQL Flexible Server to use.

## Module Outputs
This module provides the following outputs:

- 'flexible-mysql_server_id': The ID of the MySQL Flexible Server.
- 'public_network_access_enabled': Is the public network access enabled.

# Examples
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/slovink/terraform-azure-flexible-mysql/tree/master/_example) directory within this repository.

# License
This Terraform module is provided under the '[License Name]' License. Please see the [LICENSE](https://github.com/slovink/terraform-azure-flexible-mysql/blob/master/LICENSE) file for more details.

# Author
Your Name
Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.
