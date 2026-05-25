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
    booleanParam(
      name: 'AUTO_APPROVE',
      defaultValue: false,
      description: 'Allow apply or destroy without interactive confirmation.'
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

    stage('Terraform Init') {
      steps {
        dir("${params.TF_WORKING_DIR}") {
          sh '''
            set -eu

            terraform version

            if [ -n "${TF_BACKEND_RESOURCE_GROUP:-}" ] && \
               [ -n "${TF_BACKEND_STORAGE_ACCOUNT:-}" ] && \
               [ -n "${TF_BACKEND_CONTAINER:-}" ]; then
              terraform init \
                -input=false \
                -backend-config="resource_group_name=${TF_BACKEND_RESOURCE_GROUP}" \
                -backend-config="storage_account_name=${TF_BACKEND_STORAGE_ACCOUNT}" \
                -backend-config="container_name=${TF_BACKEND_CONTAINER}" \
                -backend-config="key=${TF_STATE_KEY}"
            else
              terraform init -input=false
            fi
          '''
        }
      }
    }

    stage('Terraform Validate') {
      steps {
        dir("${params.TF_WORKING_DIR}") {
          sh 'terraform validate'
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
        script {
          if (!params.AUTO_APPROVE) {
            input message: 'Approve Terraform apply for Azure AKS?', ok: 'Apply'
          }
        }
        dir("${params.TF_WORKING_DIR}") {
          sh 'terraform apply -input=false tfplan'
        }
      }
    }

    stage('Terraform Destroy') {
      when {
        expression { params.TF_ACTION == 'destroy' }
      }
      steps {
        script {
          if (!params.AUTO_APPROVE) {
            input message: 'Approve Terraform destroy for Azure AKS?', ok: 'Destroy'
          }
        }
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
