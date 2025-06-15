# outputs.tf
output "application_url" {
  description = "URL of the deployed application"
  value       = "https://${azurerm_windows_web_app.app.default_hostname}"
}

output "app_name" {
  description = "Name of the Azure App Service"
  value       = azurerm_windows_web_app.app.name
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "application_insights_app_id" {
  description = "Application Insights Application ID"
  value       = azurerm_application_insights.ai.app_id
  sensitive   = true
}

output "monitoring_dashboard_url" {
  description = "Direct link to Application Insights"
  value       = "https://portal.azure.com/#@/resource${azurerm_application_insights.ai.id}/overview"
}

output "cost_management_url" {
  description = "Direct link to cost analysis"
  value       = "https://portal.azure.com/#@/resource${azurerm_resource_group.rg.id}/costanalysis"
}

output "budget_url" {
  description = "Direct link to budget"
  value       = "https://portal.azure.com/#view/Microsoft_Azure_Billing/ModernBillingMenuBlade/~/Overview"
}

output "deployment_summary" {
  description = "Summary of deployed resources"
  value = {
    environment     = var.environment
    location       = var.location
    resource_count = 7
    estimated_cost = "€0.00/month (F1 Free Tier)"
    monitoring     = "Application Insights Enabled"
    cost_controls  = "Budget Alerts Active"
    alerting       = "Action Groups Configured"
  }
}