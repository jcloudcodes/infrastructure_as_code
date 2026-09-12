# One-time adoption of the pre-existing AKS stack into Terraform state.
#
# The cluster, resource group and VNet were created outside this state file, so
# without these blocks Terraform plans a fresh "create" and Azure rejects it.
# Import blocks are ignored once a resource is already in state, so leaving this
# file in place is harmless; you can delete it after the first successful apply.

import {
  to = azurerm_kubernetes_cluster.aks_cluster
  id = "/subscriptions/f18faa82-efd2-439c-ae36-7f0ccd369e12/resourceGroups/jcloudcodes-aks-dev-rg/providers/Microsoft.ContainerService/managedClusters/jcloudcodes-dev-aks"
}

# The AKS identity's "Network Contributor" grant on the BYO VNet almost certainly
# already exists from an earlier apply. Azure rejects a duplicate grant with
# RoleAssignmentExists, so it has to be imported too — but its id ends in a random
# GUID that only Azure knows.
#
# Run this to get it:
#
#   $vnet = "/subscriptions/f18faa82-efd2-439c-ae36-7f0ccd369e12/resourceGroups/jcloudcodes-aks-dev-rg/providers/Microsoft.Network/virtualNetworks/jcloudcodes-aks-vnet"
#   $pid  = az aks show -g jcloudcodes-aks-dev-rg -n jcloudcodes-dev-aks --query identity.principalId -o tsv
#   az role assignment list --scope $vnet --assignee $pid --role "Network Contributor" --query "[].id" -o tsv
#
# If it prints an id, paste it below and uncomment the block.
# If it prints nothing, the grant doesn't exist yet — leave this commented out and
# Terraform will create it.
#
# import {
#   to = azurerm_role_assignment.aks_network_contributor
#   id = "PASTE_THE_ROLE_ASSIGNMENT_ID_HERE"
# }
