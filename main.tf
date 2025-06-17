terraform {
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

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

}

data "azurerm_client_config" "current" {}

resource "random_string" "suffix" {
  length  = 8
  upper   = false
  special = false
}

locals {
  resource_suffix = "${var.environment}-${random_string.suffix.result}"
  common_tags = merge(var.tags, {
    Environment = var.environment
    Deployment  = "Terraform"
  })
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
  tags     = local.common_tags
}

# Log Analytics + App Insights
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.project_name}-${local.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.common_tags
}

resource "azurerm_application_insights" "ai" {
  name                = "ai-${var.project_name}-${local.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.law.id
  tags                = local.common_tags
}

# Key Vault
resource "azurerm_key_vault" "kv" {
  name                       = "kv-${var.project_name}-${random_string.suffix.result}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  # Enable RBAC authorization
  enable_rbac_authorization = true

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = local.common_tags
}

resource "azurerm_role_assignment" "current_user_kv_admin" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "app_insights_connection_string" {
  name         = "ApplicationInsights-ConnectionString"
  value        = azurerm_application_insights.ai.connection_string
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [azurerm_role_assignment.current_user_kv_admin]
  tags         = local.common_tags
}

resource "azurerm_key_vault_secret" "app_insights_key" {
  name         = "ApplicationInsights-InstrumentationKey"
  value        = azurerm_application_insights.ai.instrumentation_key
  key_vault_id = azurerm_key_vault.kv.id
  depends_on   = [azurerm_role_assignment.current_user_kv_admin]
  tags         = local.common_tags
}

# App Service Plan
resource "azurerm_service_plan" "plan" {
  name                = "asp-${var.project_name}-${local.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = "F1"
  tags                = local.common_tags
}

# Web App
resource "azurerm_windows_web_app" "app" {
  name                = "${var.project_name}-${local.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on                = false
    ftps_state               = "Disabled"
    http2_enabled            = true
    minimum_tls_version      = "1.2"
    scm_minimum_tls_version  = "1.2"
    remote_debugging_enabled = false
    use_32_bit_worker        = true

    cors {
      allowed_origins     = ["https://${var.project_name}-${local.resource_suffix}.azurewebsites.net"]
      support_credentials = false
    }
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"                   = "1",
    "ENVIRONMENT"                                = var.environment,
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.ai.instrumentation_key,
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.ai.connection_string,
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3",
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"        = "false",
    "WEBSITE_DYNAMIC_CACHE"                      = "0",
    "WEBSITE_LOCAL_CACHE_OPTION"                 = "Always",
    "WEBSITE_LOCAL_CACHE_SIZEINMB"               = "300"
  }

  tags = local.common_tags
}

# Allow app to read from Key Vault
resource "azurerm_role_assignment" "app_service_kv_reader" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_windows_web_app.app.identity[0].principal_id


}

# CDN
/*resource "azurerm_cdn_profile" "cdn" {
 name                = "cdn-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard_Microsoft"
  tags                = local.common_tags
}

resource "azurerm_cdn_endpoint" "cdn_endpoint" {
  name                = "cdnep-${var.project_name}-${random_string.suffix.result}"
  profile_name        = azurerm_cdn_profile.cdn.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  origin {
    name      = "webapp-origin"
    host_name = azurerm_windows_web_app.app.default_hostname
  }
  origin_host_header = azurerm_windows_web_app.app.default_hostname
  optimization_type  = "GeneralWebDelivery"

  delivery_rule {
    name  = "EnforceHTTPS"
    order = 1
    request_scheme_condition {
      operator     = "Equal"
      match_values = ["HTTP"]
    }
    url_redirect_action {
      redirect_type = "Found"
      protocol      = "Https"
    }
  }

  tags = local.common_tags
} */

# Alerts
resource "azurerm_monitor_action_group" "main" {
  name                = "ag-${var.project_name}-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = var.project_name

  email_receiver {
    name          = "primary-contact"
    email_address = var.alert_email
  }

  webhook_receiver {
    name        = "teams-webhook"
    service_uri = "https://outlook.office.com/webhook/placeholder"
  }

  tags = local.common_tags
}

resource "azurerm_monitor_metric_alert" "app_response_time" {
  name                = "alert-response-time-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_windows_web_app.app.id]
  description         = "Alert when average response time > 5s"

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "AverageResponseTime"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 5
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = local.common_tags
}

# Budget
resource "azurerm_consumption_budget_resource_group" "budget" {
  name              = "budget-${var.project_name}-${var.environment}"
  resource_group_id = azurerm_resource_group.rg.id
  amount            = var.budget_amount
  time_grain        = "Monthly"

  time_period {
    start_date = "2025-06-01T00:00:00Z"
    end_date   = "2026-06-01T00:00:00Z"
  }

  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThan"
    contact_emails = [var.alert_email]
  }

  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    contact_emails = [var.alert_email]
  }
}
