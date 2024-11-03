#!/bin/bash

DIR=$( pwd )
ENV=$1
ACTION=$2

function show_usage {
   echo "Error: Usage ./bin/deploy.sh [Environment] [plan|apply|destroy]"
   echo "Example ./bin/deploy.sh dev plan"
}

function ansible_deploy {
    cd ${DIR}/ansible
    [[ -d ".venv" ]] && rm -Rf .venv
    python3 -m venv .venv
    source .venv/bin/activate
    pip3 install -r requirements.txt   
    
    ansible-playbook initial-cluster-setup.yaml -e region=eu-west-1 -e env=$ENV
    ansible-playbook aws-loadbalancer-ingress.yaml -e region=eu-west-1
    ansible-playbook sample-game2048-app.yaml -e region=eu-west-1
}

function apply {
    ln -sf $DIR/secrets/$ENV/tf_backend.tf terraform/tf_backend.tf
    cd terraform
    rm -rf .terraform .terraform.lock.hcl
    terraform --version | grep `cat .tfenv-version` # Make sure to use repository defined TF version (tfenv)
    terraform init
    echo $DIR
    terraform apply -var-file $DIR/secrets/$ENV/terraform.tfvars

    [[ $? -eq 1 ]] && exit 0

     ansible_deploy
}

function plan {
    ln -sf $DIR/secrets/$ENV/tf_backend.tf terraform/tf_backend.tf
    cd terraform
    rm -rf .terraform .terraform.lock.hcl
    terraform --version | grep `cat .tfenv-version` # Make sure to use repository defined TF version (tfenv)
    terraform init
    terraform plan -var-file $DIR/secrets/$ENV/terraform.tfvars
}

function destroy {
    ln -sf $DIR/secrets/$ENV/tf_backend.tf terraform/tf_backend.tf
    cd terraform
    rm -rf .terraform .terraform.lock.hcl
    terraform --version | grep `cat .tfenv-version` # Make sure to use repository defined TF version (tfenv)
    terraform init
    terraform destroy -var-file $DIR/secrets/$ENV/terraform.tfvars
}

function execute {
    [[ $ACTION == "plan" ]] && plan
    [[ $ACTION == "apply" ]] && apply
    [[ $ACTION == "destroy" ]] && destroy
}

[[ "$#" -ne 2 ]] && show_usage

execute $ENV $ACTION