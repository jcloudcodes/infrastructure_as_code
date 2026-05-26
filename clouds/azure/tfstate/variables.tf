variable "azure_subscription_id" {
  description = "Azure subscription ID where the Terraform state resources will be created"
  type        = string
}

variable "azure_location" {
  description = "Azure region for Terraform state resources"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Resource group name for Terraform state resources"
  type        = string
}

variable "storage_account_name" {
  description = "Globally unique Azure Storage account name for Terraform state"
  type        = string
}

variable "container_name" {
  description = "Blob container name for Terraform state"
  type        = string
  default     = "tfstate"
}

variable "account_tier" {
  description = "Azure Storage account tier"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Azure Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "dev"
}

variable "business_divsion" {
  description = "Business division tag value"
  type        = string
  default     = "SAP"
}
