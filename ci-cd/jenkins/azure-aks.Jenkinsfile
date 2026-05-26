pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
    disableConcurrentBuilds()
  }

  parameters {
    choice(
      name: 'TF_ACTION',
      choices: ['plan', 'apply', 'destroy'],
      description: 'Terraform action to run for the Azure AKS stack.'
    )
    string(
      name: 'TF_WORKING_DIR',
      defaultValue: 'clouds/azure/aks',
      description: 'Path to the Terraform AKS folder from the infrastructure_as_code repository root.'
    )
    string(
      name: 'TF_VARS_FILE',
      defaultValue: 'aks.auto.tfvars',
      description: 'Terraform variables file to use.'
    )
    string(
      name: 'TF_STATE_KEY',
      defaultValue: 'infra/azure/aks/terraform.tfstate',
      description: 'Remote backend state key when backend config is supplied.'
    )
  }

  environment {
    TF_IN_AUTOMATION = 'true'
    TF_INPUT         = 'false'
    ARM_CLIENT_ID       = credentials('azure-client-id')
    ARM_CLIENT_SECRET   = credentials('azure-client-secret')
    ARM_SUBSCRIPTION_ID = credentials('azure-subscription-id')
    ARM_TENANT_ID       = credentials('azure-tenant-id')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Format') {
      steps {
        dir("${params.TF_WORKING_DIR}") {
          sh 'terraform fmt -check -recursive'
        }
      }
    }

    stage('Terraform Init And Validate') {
      steps {
        dir("${params.TF_WORKING_DIR}") {
          sh '''
            set -eu

            terraform version

            test -n "${TF_BACKEND_RESOURCE_GROUP:-}" || { echo "Missing TF_BACKEND_RESOURCE_GROUP environment variable."; exit 1; }
            test -n "${TF_BACKEND_STORAGE_ACCOUNT:-}" || { echo "Missing TF_BACKEND_STORAGE_ACCOUNT environment variable."; exit 1; }
            test -n "${TF_BACKEND_CONTAINER:-}" || { echo "Missing TF_BACKEND_CONTAINER environment variable."; exit 1; }

            terraform init \
              -input=false \
              -backend-config="resource_group_name=${TF_BACKEND_RESOURCE_GROUP}" \
              -backend-config="storage_account_name=${TF_BACKEND_STORAGE_ACCOUNT}" \
              -backend-config="container_name=${TF_BACKEND_CONTAINER}" \
              -backend-config="key=${TF_STATE_KEY}"

            terraform validate
          '''
        }
      }
    }

    stage('Terraform Plan') {
      when {
        expression { params.TF_ACTION == 'plan' || params.TF_ACTION == 'apply' }
      }
      steps {
        dir("${params.TF_WORKING_DIR}") {
          sh '''
            set -eu
            terraform plan \
              -input=false \
              -var-file="${TF_VARS_FILE}" \
              -out=tfplan
          '''
        }
      }
    }

    stage('Terraform Apply') {
      when {
        expression { params.TF_ACTION == 'apply' }
      }
      steps {
        dir("${params.TF_WORKING_DIR}") {
          sh '''
            terraform apply \
              -input=false \
              -auto-approve \
              tfplan
          '''
        }
      }
    }

    stage('Show AKS Details') {
      when {
        expression { params.TF_ACTION == 'apply' }
      }
      steps {
        dir("${params.TF_WORKING_DIR}") {
          sh '''
            set -eu

            az login --service-principal \
              --username "${ARM_CLIENT_ID}" \
              --password "${ARM_CLIENT_SECRET}" \
              --tenant "${ARM_TENANT_ID}" \
              --output none

            az account set --subscription "${ARM_SUBSCRIPTION_ID}"

            RESOURCE_GROUP_NAME="$(terraform output -raw resource_group_name)"
            CLUSTER_NAME="$(terraform output -raw cluster_name)"

            az aks show \
              --resource-group "${RESOURCE_GROUP_NAME}" \
              --name "${CLUSTER_NAME}" \
              --query "{name:name,location:location,kubernetesVersion:kubernetesVersion,resourceGroup:resourceGroup,nodeResourceGroup:nodeResourceGroup,provisioningState:provisioningState,fqdn:fqdn}" \
              --output table
          '''
        }
      }
    }

    stage('Terraform Destroy') {
      when {
        expression { params.TF_ACTION == 'destroy' }
      }
      steps {
        dir("${params.TF_WORKING_DIR}") {
          sh '''
            terraform destroy \
              -input=false \
              -auto-approve \
              -var-file="${TF_VARS_FILE}"
          '''
        }
      }
    }
  }
}
