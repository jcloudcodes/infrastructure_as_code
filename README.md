# infrastructure_as_code

GitHub: [jcloudcodes/infrastructure_as_code](https://github.com/jcloudcodes/infrastructure_as_code.git)

## Azure AKS Terraform

The first Azure AKS environment, including the network used by AKS, was created manually from the command line. This repository now automates that provisioning with Terraform and CI/CD.

Terraform path:

- [clouds/azure/aks](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/clouds/azure/aks)

CI/CD paths:

- GitHub Actions workflow:
  [.github/workflows/azure-aks-plan.yml](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/.github/workflows/azure-aks-plan.yml)
- GitHub Actions apply workflow:
  [.github/workflows/azure-aks-apply.yml](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/.github/workflows/azure-aks-apply.yml)
- GitHub Actions destroy workflow:
  [.github/workflows/azure-aks-destroy.yml](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/.github/workflows/azure-aks-destroy.yml)
- GitHub Actions implementation:
  [ci-cd/github_action/aks/action.yml](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/ci-cd/github_action/aks/action.yml)
- Jenkins pipeline:
  [ci-cd/jenkins/azure-aks.Jenkinsfile](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/ci-cd/jenkins/azure-aks.Jenkinsfile)

## GitHub Action Usage

GitHub settings location:

1. Open the GitHub repository.
2. Go to `Settings`.
3. Go to `Secrets and variables`.
4. Open `Actions`.
5. Add values under `Repository secrets` or `Repository variables`.

Create these GitHub repository secrets:

- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_TENANT_ID`

These are the same Azure values used by Jenkins, only stored in GitHub under uppercase secret names.

Optional backend secrets:

- `TF_BACKEND_RESOURCE_GROUP`
- `TF_BACKEND_STORAGE_ACCOUNT`
- `TF_BACKEND_CONTAINER`

Optional repository variables:

- `TF_STATE_KEY`
- `TF_WORKING_DIR`
- `TF_VARS_FILE`

Workflow inputs:

- `tf_working_dir`: `clouds/azure/aks`
- `tf_vars_file`: `aks.auto.tfvars`
- `tf_state_key`: `infra/azure/aks/terraform.tfstate`

Trigger behavior:

- `Azure AKS Plan` runs automatically on push to `main`
- automatic plan runs only trigger when AKS files change under `clouds/azure/aks`, `ci-cd/github_action/aks`, or the AKS workflow files
- `Azure AKS Apply` is a separate manual workflow in the GitHub Actions UI
- `Azure AKS Apply` uses Terraform auto-approve
- `Azure AKS Destroy` is a separate manual workflow in the GitHub Actions UI
- `Azure AKS Destroy` uses Terraform auto-approve
- each workflow shows only its own jobs, so push runs no longer show skipped `apply` or `destroy`

## Jenkins Usage

Create these Jenkins secret text credentials:

- `azure-client-id`
- `azure-client-secret`
- `azure-subscription-id`
- `azure-tenant-id`

These are the same Azure values used in GitHub Actions, only stored in Jenkins under lowercase credential names.

Optional Jenkins backend variables:

- `TF_BACKEND_RESOURCE_GROUP`
- `TF_BACKEND_STORAGE_ACCOUNT`
- `TF_BACKEND_CONTAINER`

Jenkins parameters:

- `TF_ACTION`: `plan`, `apply`, or `destroy`
- `TF_WORKING_DIR`: `clouds/azure/aks`
- `TF_VARS_FILE`: `aks.auto.tfvars`
- `TF_STATE_KEY`: `infra/azure/aks/terraform.tfstate`
- `AUTO_APPROVE`: `true` or `false`

## Azure CLI Commands

Login first:

```bash
az login
```

Get the Azure subscription ID:

```bash
az account show --query id --output tsv
```

Get the Azure tenant ID:

```bash
az account show --query tenantId --output tsv
```

Create a new service principal and get `client_id`, `client_secret`, `subscription_id`, and `tenant_id` in one command:

```bash
az ad sp create-for-rbac \
  --name "sp-azure-aks-terraform" \
  --role Contributor \
  --scopes "/subscriptions/$(az account show --query id --output tsv)"
```

From the output:

- `appId` = `azure-client-id`
- `password` = `azure-client-secret`
- `tenant` = `azure-tenant-id`
- `az account show --query id --output tsv` = `azure-subscription-id`

If the service principal already exists and you need a new client secret, reset it:

```bash
az ad app credential reset --id <APP_ID>
```

Get AKS cluster details after apply:

```bash
az aks show \
  --resource-group <RESOURCE_GROUP_NAME> \
  --name <CLUSTER_NAME> \
  --query "{name:name,location:location,kubernetesVersion:kubernetesVersion,resourceGroup:resourceGroup,nodeResourceGroup:nodeResourceGroup,provisioningState:provisioningState,fqdn:fqdn}" \
  --output table
```

List AKS clusters in the current subscription:

```bash
az aks list --output table
```

Note:

- Azure does not let you read an existing client secret value back after creation.
- If you do not have the current secret, create a new one with `az ad app credential reset` or create a new service principal.
