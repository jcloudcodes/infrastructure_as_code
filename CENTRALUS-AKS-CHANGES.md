# Central US AKS changes

This copy was adjusted for the current jcloudcodes Azure lab.

## Changed

- Azure subscription: `f18faa82-efd2-439c-ae36-7f0ccd369e12`
- Azure tenant: `e12bc39a-61a0-40ad-baef-91b20ca4e856`
- Region: `centralus`
- Resource group: `jcloudcodes-aks-dev-rg`
- Cluster name: `jcloudcodes-dev-aks` (used exactly, no SAP/dev name prefix)
- Existing VNet: `jcloudcodes-aks-vnet`
- Existing AKS subnet: `aks-subnet`
- Node size: `Standard_D2s_v7`
- Autoscaling: min 1, max 2
- Added a Terraform `Network Contributor` assignment for the AKS system-assigned managed identity at VNet scope.

## Important

The GitHub Actions service principal running Terraform must be allowed to create Azure role assignments at the VNet scope (for example, Owner or User Access Administrator plus the necessary resource permissions). No client secret is stored in this repository; continue using GitHub repository secrets.

The AKS Terraform expects the resource group, VNet, and `aks-subnet` to already exist.
