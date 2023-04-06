# East US
resource "azurerm_service_plan" "tom_service_plan_eastus" {
  name                = "TimeOffManagement-SP-eastus"
  resource_group_name = azurerm_resource_group.tom_resource_group_eastus.name
  location            = azurerm_resource_group.tom_resource_group_eastus.location
  os_type             = "Linux"
  sku_name            = "B1"
  worker_count        = 2
}

resource "azurerm_linux_web_app" "tom_linux_web_app_eastus" {
  name                = "TimeOffManagement-LWA-eastus"
  resource_group_name = azurerm_resource_group.tom_resource_group_eastus.name
  location            = azurerm_service_plan.tom_service_plan_eastus.location
  service_plan_id     = azurerm_service_plan.tom_service_plan_eastus.id
  https_only          = true
  site_config {
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"
    # ip_restriction {
    #   service_tag               = "AzureFrontDoor.Backend"
    #   ip_address                = null
    #   virtual_network_subnet_id = null
    #   action                    = "Allow"
    #   priority                  = 100
    #   headers = [{
    #     x_azure_fdid      = [azurerm_cdn_frontdoor_profile.tom_front_door.resource_guid]
    #     x_fd_health_probe = []
    #     x_forwarded_for   = []
    #     x_forwarded_host  = []
    #   }]
    #   name = "Allow traffic from Front Door"
    # }
    application_stack {
      node_version = "14-lts"
    }
  }

}

# North Central US
resource "azurerm_service_plan" "tom_service_plan_bs" {
  name                = "TimeOffManagement-SP-bs"
  resource_group_name = azurerm_resource_group.tom_resource_group_bs.name
  location            = azurerm_resource_group.tom_resource_group_bs.location
  os_type             = "Linux"
  sku_name            = "B1"
  worker_count        = 2
}

resource "azurerm_linux_web_app" "tom_linux_web_app_bs" {
  name                = "TimeOffManagement-LWA-westus"
  resource_group_name = azurerm_resource_group.tom_resource_group_bs.name
  location            = azurerm_service_plan.tom_service_plan_bs.location
  service_plan_id     = azurerm_service_plan.tom_service_plan_bs.id
  https_only          = true
  site_config {
    ftps_state          = "Disabled"
    minimum_tls_version = "1.2"
    # ip_restriction {
    #   service_tag               = "AzureFrontDoor.Backend"
    #   ip_address                = null
    #   virtual_network_subnet_id = null
    #   action                    = "Allow"
    #   priority                  = 100
    #   headers = [{
    #     x_azure_fdid      = [azurerm_cdn_frontdoor_profile.tom_front_door.resource_guid]
    #     x_fd_health_probe = []
    #     x_forwarded_for   = []
    #     x_forwarded_host  = []
    #   }]
    #   name = "Allow traffic from Front Door"
    # }
    application_stack {
      node_version = "14-lts"
    }
  }

}