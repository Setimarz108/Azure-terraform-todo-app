variable "environment" {
  description = "Environment name (dev, staging, prod, demo)"
  type        = string
  default     = "demo"

  validation {
    condition     = contains(["dev", "staging", "prod", "demo"], var.environment)
    error_message = "Environment must be dev, staging, prod, or demo."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "northeurope"
}

variable "budget_amount" {
  description = "Monthly budget amount in EUR"
  type        = number
  default     = 5
}

variable "alert_email" {
  description = "Email for monitoring alerts"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.alert_email))
    error_message = "Must be a valid email address."
  }
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "TodoApp"
}

variable "tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default = {
    Project     = "TodoApp"
    Owner       = "CloudEngineer"
    Environment = "Demo"
    CostCenter  = "Development"
  }
}