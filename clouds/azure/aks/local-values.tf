locals {
  owners      = var.business_divsion
  environment = var.environment

  normalized_owner = replace(replace(replace(replace(lower(local.owners), " ", "-"), "_", "-"), ".", "-"), "/", "-")
  normalized_env   = replace(replace(replace(replace(lower(local.environment), " ", "-"), "_", "-"), ".", "-"), "/", "-")

  base_name_raw = "${local.normalized_owner}-${local.normalized_env}"
  base_name     = trimspace(trim(local.base_name_raw, "-"))
  safe_prefix   = length(regexall("^[a-z]", local.base_name)) > 0 ? local.base_name : "a-${local.base_name}"

  name = local.safe_prefix

  cluster_name_suffix_raw = replace(replace(replace(replace(lower(var.cluster_name), " ", "-"), "_", "-"), ".", "-"), "/", "-")
  cluster_name_suffix     = trim(local.cluster_name_suffix_raw, "-")
  aks_cluster_name_raw    = "${local.name}-${local.cluster_name_suffix}"
  aks_cluster_name        = substr(trim(local.aks_cluster_name_raw, "-"), 0, 63)

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
