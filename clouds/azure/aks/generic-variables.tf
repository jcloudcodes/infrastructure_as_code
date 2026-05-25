variable "azure_subscription_id" {
  description = "Azure subscription ID where AKS resources will be created"
  type        = string
}

variable "azure_tenant_id" {
  description = "Azure tenant ID used by AKS and optional Entra admin integration"
  type        = string
  default     = null
}

variable "azure_location" {
  description = "Azure region where AKS resources will be created"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Azure resource group name for the AKS cluster"
  type        = string
}

variable "environment" {
  description = "Environment name used in resource naming"
  type        = string
  default     = "dev"
}

variable "business_divsion" {
  description = "Business division this infrastructure belongs to"
  type        = string
  default     = "SAP"
}
