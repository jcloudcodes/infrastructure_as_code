# Azure AKS Terraform

This folder provisions an Azure Kubernetes Service cluster by using Terraform.

## Files

- [aks-cluster.tf](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/clouds/azure/aks/aks-cluster.tf)
- [aks-variables.tf](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/clouds/azure/aks/aks-variables.tf)
- [generic-variables.tf](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/clouds/azure/aks/generic-variables.tf)
- [aks.auto.tfvars](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/clouds/azure/aks/aks.auto.tfvars)
- [ci-cd/jenkins/azure-aks.Jenkinsfile](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/ci-cd/jenkins/azure-aks.Jenkinsfile)
- [.github/workflows/azure-aks-terraform.yml](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/.github/workflows/azure-aks-terraform.yml)
- [.gitlab-ci.yml](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/.gitlab-ci.yml)
- [ci-cd/github_action/aks/action.yml](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/ci-cd/github_action/aks/action.yml)
- [ci-cd/gitlab/azure-aks.gitlab-ci.yml](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/ci-cd/gitlab/azure-aks.gitlab-ci.yml)

## Before You Run

Make sure these Azure resources already exist:

- Resource group
- Virtual network
- Subnet used by `vnet_subnet_id`

This Terraform stack creates AKS, but it does not create the network.

## Main Parameters

Update [aks.auto.tfvars](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/clouds/azure/aks/aks.auto.tfvars) with your values:

| Parameter | Description |
| --- | --- |
| `azure_subscription_id` | Azure subscription ID |
| `azure_tenant_id` | Azure tenant ID |
| `azure_location` | Azure region |
| `resource_group_name` | Existing resource group name |
| `cluster_name` | AKS cluster name suffix |
| `vnet_subnet_id` | Existing subnet resource ID |
| `node_pool_vm_size` | VM size for worker nodes |
| `node_pool_enable_auto_scaling` | Enable or disable autoscaling |
| `node_pool_desired_size` | Node count when autoscaling is disabled |
| `node_pool_min_size` | Minimum node count when autoscaling is enabled |
| `node_pool_max_size` | Maximum node count when autoscaling is enabled |
| `node_pool_zones` | Availability zones |
| `admin_group_object_ids` | Optional Entra admin group IDs |
| `acr_id` | Optional ACR ID for `AcrPull` |

## Jenkins Secrets

Create these Jenkins credentials as secret text:

- `azure-client-id`
- `azure-client-secret`
- `azure-subscription-id`
- `azure-tenant-id`

Optional backend environment variables:

- `TF_BACKEND_RESOURCE_GROUP`
- `TF_BACKEND_STORAGE_ACCOUNT`
- `TF_BACKEND_CONTAINER`

## GitHub Secrets

Create these GitHub repository secrets:

- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_TENANT_ID`

Optional backend secrets:

- `TF_BACKEND_RESOURCE_GROUP`
- `TF_BACKEND_STORAGE_ACCOUNT`
- `TF_BACKEND_CONTAINER`

## Run Locally

```bash
cd /Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/clouds/azure/aks
terraform init
terraform validate
terraform plan -var-file=aks.auto.tfvars
terraform apply -var-file=aks.auto.tfvars
```
