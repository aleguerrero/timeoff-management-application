resource "azurerm_log_analytics_workspace" "tom_log_analytics_workspace" {
  name                = "tom-law"
  location            = azurerm_resource_group.tom_resource_group_centalus.location
  resource_group_name = azurerm_resource_group.tom_resource_group_centalus.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "tom_monitor_diagnostic_settings" {
  name                       = "tom-mds"
  target_resource_id         = azurerm_cdn_frontdoor_profile.tom_front_door.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.tom_log_analytics_workspace.id

  enabled_log {
    category_group = "allLogs"
    retention_policy {
      enabled = false
    }
  }
}