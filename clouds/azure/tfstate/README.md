# Azure TFState Terraform

This folder bootstraps the Azure Storage backend used by Terraform state.

Create this first before running the AKS Terraform workflows.

## Files

- [backend.tf](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/clouds/azure/tfstate/backend.tf)
- [variables.tf](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/clouds/azure/tfstate/variables.tf)
- [main.tf](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/clouds/azure/tfstate/main.tf)
- [outputs.tf](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/clouds/azure/tfstate/outputs.tf)
- [tfstate.auto.tfvars](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/clouds/azure/tfstate/tfstate.auto.tfvars)

## What It Creates

- Azure resource group
- Azure Storage account
- Blob container named `tfstate`

## Run Order

1. Apply the TFState stack.
2. Add these values to GitHub or Jenkins:
   - `TF_BACKEND_RESOURCE_GROUP`
   - `TF_BACKEND_STORAGE_ACCOUNT`
   - `TF_BACKEND_CONTAINER`
3. Run the AKS plan or apply workflow.
