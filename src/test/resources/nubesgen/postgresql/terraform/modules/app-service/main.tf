
# This creates the plan that the service use
resource "azurerm_app_service_plan" "compute" {
  name                = "${var.application_name}-plan"
  resource_group_name = var.resource_group
  location            = var.location

  kind     = "Linux"
  reserved = true

  sku {
    tier = var.sku_tier
    size = var.sku_size
  }
}

# This creates the service definition
resource "azurerm_app_service" "compute" {
  name                = var.application_name
  resource_group_name = var.resource_group
  location            = var.location
  app_service_plan_id = azurerm_app_service_plan.compute.id
  https_only          = true

  site_config {
    always_on        = true
    linux_fx_version = "JAVA|11-java11"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"

    # These are app specific environment variables
    "SPRING_PROFILES_ACTIVE"     = "prod,azure"
    "SPRING_DATASOURCE_URL"      = "jdbc:postgresql://${var.database_url}"
    "SPRING_DATASOURCE_USERNAME" = var.database_username
    "SPRING_DATASOURCE_PASSWORD" = var.database_password
  }
}
