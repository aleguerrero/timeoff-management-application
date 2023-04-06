locals {
  front_door_profile_name       = "tom-frontdoor-profile"
  front_door_endpoint_name      = "tom-frontdoor-endpoint"
  front_door_origin_group_name  = "tom-origin-group"
  front_door_origin_name_eastus = "tom-frontdoor-origin-eastus"
  front_door_origin_name_bs   = "tom-frontdoor-origin-bs"
  front_door_route_name         = "tom-frontdoor-route"
}

resource "azurerm_cdn_frontdoor_profile" "tom_front_door" {
  name                = local.front_door_profile_name
  resource_group_name = azurerm_resource_group.tom_resource_group_centalus.name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "tom_endpoint" {
  name                     = local.front_door_endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.tom_front_door.id
}

resource "azurerm_cdn_frontdoor_origin_group" "tom_origin_group" {
  name                     = local.front_door_origin_group_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.tom_front_door.id
  session_affinity_enabled = true

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin" "tom_app_service_origin_eastus" {
  name                          = local.front_door_origin_name_eastus
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.tom_origin_group.id

  enabled                        = true
  host_name                      = azurerm_linux_web_app.tom_linux_web_app_eastus.default_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_linux_web_app.tom_linux_web_app_eastus.default_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_origin" "tom_app_service_origin_bs" {
  name                          = local.front_door_origin_name_bs
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.tom_origin_group.id

  enabled                        = true
  host_name                      = azurerm_linux_web_app.tom_linux_web_app_bs.default_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_linux_web_app.tom_linux_web_app_bs.default_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "my_route" {
  name                          = local.front_door_route_name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.tom_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.tom_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.tom_app_service_origin_eastus.id, azurerm_cdn_frontdoor_origin.tom_app_service_origin_bs.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  link_to_default_domain = true
  https_redirect_enabled = true
}