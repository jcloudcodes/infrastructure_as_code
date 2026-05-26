locals {
  owners      = var.business_divsion
  environment = var.environment

  normalized_owner = replace(replace(replace(replace(lower(local.owners), " ", "-"), "_", "-"), ".", "-"), "/", "-")
  normalized_env   = replace(replace(replace(replace(lower(local.environment), " ", "-"), "_", "-"), ".", "-"), "/", "-")

  common_tags = {
    owners      = local.normalized_owner
    environment = local.normalized_env
    ManagedBy   = "Terraform"
    Layer       = "TFState"
  }
}
