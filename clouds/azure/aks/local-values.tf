locals {
  owners      = var.business_divsion
  environment = var.environment

  normalized_owner = replace(replace(replace(replace(lower(local.owners), " ", "-"), "_", "-"), ".", "-"), "/", "-")
  normalized_env   = replace(replace(replace(replace(lower(local.environment), " ", "-"), "_", "-"), ".", "-"), "/", "-")

  base_name_raw = "${local.normalized_owner}-${local.normalized_env}"
  base_name     = trimspace(trim(local.base_name_raw, "-"))
  safe_prefix   = length(regexall("^[a-z]", local.base_name)) > 0 ? local.base_name : "a-${local.base_name}"

  name = local.safe_prefix

  # Use the configured AKS cluster name exactly (for example, jcloudcodes-dev-aks).
  aks_cluster_name = var.cluster_name

  dns_prefix = var.dns_prefix == null ? local.aks_cluster_name : (
    trimspace(var.dns_prefix) == "" ? local.aks_cluster_name : var.dns_prefix
  )

  common_tags = {
    owners      = local.normalized_owner
    environment = local.normalized_env
    ManagedBy   = "Terraform"
    Layer       = "AKS"
  }
}
