terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.50.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tom_resource_group_eastus" {
  name     = "TimeOffManagement-RG-001"
  location = "East US"
}

resource "azurerm_resource_group" "tom_resource_group_bs" {
  name     = "TimeOffManagement-RG-002"
  location = "Brazil South"
}

resource "azurerm_resource_group" "tom_resource_group_centralus" {
  name     = "TimeOffManagement-RG-FD"
  location = "centralus"
}
