output "cluster_id" {
  description = "The ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.id
}

output "cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.name
}

output "cluster_fqdn" {
  description = "The FQDN of the AKS Kubernetes API"
  value       = azurerm_kubernetes_cluster.aks_cluster.fqdn
}

output "cluster_version" {
  description = "The Kubernetes version for the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.kubernetes_version
}

output "resource_group_name" {
  description = "The Azure resource group name used by AKS"
  value       = azurerm_resource_group.aks_rg.name
}

output "vnet_id" {
  description = "Resource ID of the virtual network created for this stack"
  value       = azurerm_virtual_network.aks_vnet.id
}

output "aks_subnet_id" {
  description = "Resource ID of the AKS node subnet"
  value       = azurerm_subnet.aks_subnet.id
}

output "node_resource_group" {
  description = "The managed node resource group created by AKS"
  value       = azurerm_kubernetes_cluster.aks_cluster.node_resource_group
}

output "cluster_identity_principal_id" {
  description = "Principal ID for the AKS system-assigned identity"
  value       = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
}

output "kubelet_identity_object_id" {
  description = "Object ID for the AKS kubelet identity"
  value       = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL for AKS workload identity"
  value       = azurerm_kubernetes_cluster.aks_cluster.oidc_issuer_url
}

output "ingress_subnet_id" {
  description = "Subnet the internal ingress load balancer should use"
  value       = azurerm_subnet.ingress_subnet.id
}

output "ingress_nsg_id" {
  description = "Resource ID of the NSG attached to the ingress subnet"
  value       = azurerm_network_security_group.ingress_nsg.id
}

output "ingress_annotations_hint" {
  description = "Service annotations that match this stack's networking"
  value = {
    "service.beta.kubernetes.io/azure-load-balancer-internal"        = "true"
    "service.beta.kubernetes.io/azure-load-balancer-internal-subnet" = azurerm_subnet.ingress_subnet.name
    "service.beta.kubernetes.io/azure-load-balancer-ipv4"            = var.ingress_loadbalancer_ip
  }
}
