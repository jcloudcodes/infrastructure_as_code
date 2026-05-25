terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Uncomment and fill these when you are ready to store AKS state in Azure Storage.
  # backend "azurerm" {
  #   resource_group_name  = "replace-with-tfstate-rg"
  #   storage_account_name = "replacewithtfstateacct"
  #   container_name       = "tfstate"
  #   key                  = "infra/aks/terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}
