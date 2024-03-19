# Terraform version
terraform {
  required_version = ">=1.7.4"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.87.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0, < 4.0" # Specify the appropriate version constraint
    }
  }
}
