terraform {
  required_version = "~> 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Random string and integer for resource naming
resource "random_pet" "resource_suffix" {}

resource "random_integer" "entropy" {
  min = 100
  max = 999
}

# Temporary resources for Terraform test
resource "azurerm_log_analytics_workspace" "monitoring" {
  name                = local.resource_name.log_analytics_workspace
  location            = var.location
  resource_group_name = var.resource_group_name
}
