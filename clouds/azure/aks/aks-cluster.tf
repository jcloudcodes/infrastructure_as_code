resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                    = local.aks_cluster_name
  location                = azurerm_resource_group.aks_rg.location
  resource_group_name     = azurerm_resource_group.aks_rg.name
  dns_prefix              = local.dns_prefix
  kubernetes_version      = var.cluster_version
  sku_tier                = var.sku_tier
  private_cluster_enabled = var.private_cluster_enabled
  private_dns_zone_id     = var.private_cluster_enabled ? var.private_dns_zone_id : null

  default_node_pool {
    temporary_name_for_rotation = var.node_pool_temporary_name_for_rotation
    name                        = var.node_pool_name
    vm_size                     = var.node_pool_vm_size

    # Use the AKS subnet created by Terraform.
    vnet_subnet_id = azurerm_subnet.aks_subnet.id

    type            = var.node_pool_type
    os_disk_size_gb = var.node_pool_os_disk_size_gb
    os_disk_type    = var.node_pool_os_disk_type
    max_pods        = var.node_pool_max_pods
    zones           = var.node_pool_zones

    auto_scaling_enabled = var.node_pool_enable_auto_scaling

    node_count = var.node_pool_enable_auto_scaling ? null : var.node_pool_desired_size
    min_count  = var.node_pool_enable_auto_scaling ? var.node_pool_min_size : null
    max_count  = var.node_pool_enable_auto_scaling ? var.node_pool_max_size : null

    tags = local.common_tags
  }

  identity {
    type = "SystemAssigned"
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = length(var.admin_group_object_ids) > 0 ? [1] : []

    content {
      tenant_id              = var.azure_tenant_id
      azure_rbac_enabled     = true
      admin_group_object_ids = var.admin_group_object_ids
    }
  }

  network_profile {
    network_plugin    = var.network_plugin
    network_policy    = var.network_policy
    load_balancer_sku = var.load_balancer_sku
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  tags = local.common_tags

  depends_on = [
    azurerm_subnet.aks_subnet,
    azurerm_subnet.ingress_subnet,
    azurerm_subnet_network_security_group_association.ingress
  ]
}


# The AKS control-plane managed identity needs Network Contributor
# permissions on the entire AKS VNet.
#
# This allows AKS to manage networking resources such as internal
# Azure Load Balancers across the AKS and ingress subnets.
resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = azurerm_virtual_network.aks_vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
}


# Optional ACR pull permission.
# This resource is only created when acr_id contains a valid resource ID.
resource "azurerm_role_assignment" "aks_acr_pull" {
  count = var.acr_id == null ? 0 : (
    trimspace(var.acr_id) == "" ? 0 : 1
  )

  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
}