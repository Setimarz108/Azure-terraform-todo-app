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
  subscription_id = "135aee60-f0b2-444a-b29a-e16361ecb782"
}

data "azurerm_client_config" "current" {}

resource "random_string" "suffix" {
  length  = 8
  upper   = false
  special = false
}

# Resource naming locals for consistency
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
  
  tags = local.common_tags
}

# Log Analytics Workspace for centralized logging
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.project_name}-${local.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  
  tags = merge(local.common_tags, {
    Purpose = "Monitoring"
  })
}

# Application Insights for observability
resource "azurerm_application_insights" "ai" {
  name                = "ai-${var.project_name}-${local.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.law.id
  
  tags = merge(local.common_tags, {
    Purpose = "Monitoring"
  })
}

# Action Group for professional alerting
resource "azurerm_monitor_action_group" "main" {
  name                = "ag-${var.project_name}-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = var.project_name

  email_receiver {
    name          = "primary-contact"
    email_address = var.alert_email
  }

  # Webhook for future integration (Teams, Slack, etc.)
  webhook_receiver {
    name        = "teams-webhook"
    service_uri = "https://outlook.office.com/webhook/placeholder"
  }

  tags = merge(local.common_tags, {
    Purpose = "Alerting"
  })
}

# Alert rule for application performance
resource "azurerm_monitor_metric_alert" "app_response_time" {
  name                = "alert-response-time-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_windows_web_app.app.id]
  description         = "Alert when average response time is greater than 5 seconds"
  
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

resource "azurerm_service_plan" "plan" {
  name                = "asp-${var.project_name}-${local.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Windows"
  sku_name            = "F1"
  
  tags = local.common_tags
}

resource "azurerm_windows_web_app" "app" {
  name                = "${var.project_name}-${local.resource_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    always_on = false
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"              = "1"
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.ai.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.ai.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "ENVIRONMENT"                           = var.environment
  }
  
  tags = local.common_tags
}

# Budget with configurable amount
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
  
  # Additional notification at 100%
  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    contact_emails = [var.alert_email]
  }
}