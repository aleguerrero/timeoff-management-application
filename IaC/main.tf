terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
  }
  required_version = ">= 0.14.9"
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "TOM" {
  name     = "TimeOffManagement-RG"
  location = "eastus"
}

resource "azurerm_service_plan" "TOM" {
  name                = "TimeOffManagement-SP"
  resource_group_name = azurerm_resource_group.TOM.name
  location            = azurerm_resource_group.TOM.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "TOM" {
  name                = "TimeOffManagement-LWA"
  resource_group_name = azurerm_resource_group.TOM.name
  location            = azurerm_service_plan.TOM.location
  service_plan_id     = azurerm_service_plan.TOM.id
  https_only          = true
  site_config {
    minimum_tls_version = "1.2"
  }
}