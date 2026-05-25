# GitHub Actions Layout

This folder stores GitHub Actions implementations by Azure resource type.

## Paths

- [aks/action.yml](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/ci-cd/github_action/aks/action.yml)
  points to [clouds/azure/aks](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/clouds/azure/aks)
- [vms/action.yml](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/ci-cd/github_action/vms/action.yml)
  points to [clouds/azure/vms](/Users/makutaworldmpm/Desktop/eagunu_2025/jcloudcodes/iac/infrastructure_as_code/clouds/azure/vms)

Use the root workflow in `.github/workflows` only as a launcher. Keep the resource-specific Terraform logic here.
