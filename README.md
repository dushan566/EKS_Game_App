# EKS_Game_App
Sample Game App provisioned in EKS

## Seup your AWS Credentials
```
[profile app1-dev-eks-admin]
role_arn = arn:aws:iam::xxxxxxxxxxxxx:role/app1-dev-eks-admin
source_profile = yourDefaultProfile

[profile app1-dev-eks-developer]
role_arn = arn:aws:iam::xxxxxxxxxxxxx:role//app1-dev-eks-developer
source_profile = yourDefaultProfile

[profile app1-dev-eks-readonly]
role_arn = arn:aws:iam::xxxxxxxxxxxxx:role//app1-dev-eks-readonly
source_profile = yourDefaultProfile
```

## Validate your credentials
Check whether you can assume profile. This is only a debug step
```aws sts assume-role \
  --role-arn "assume-role-arn" \
  --role-session-name manager-session \
  --profile EKS-Developer
```

## Get access to EKS cluster

### Step 1
Make sure to call to the correct cluster name and and profile inorder to save kubeconfig file to your local path ~/.kube/config
```
unset KUBECONFIG
aws eks --region eu-west-1 update-kubeconfig --name myapp-dev-eks-cluster --profile app1-dev-eks-readonly
``` 

### Step 2
Rename your kubeconfig file to a meaningful name to avoid accidental mess on other clusters
```
mv ~/.kube/config ~/.kube/app1-dev-eks-readonly
```

### Step 3
Export kubeconfig files to set the as default
```
export KUBECONFIG=~/.kube/app1-dev-eks-readonly
```

## Validation
Check IAM permission associated with kube-config to make sure you are accessing the correct cluster
```
kubectl config view --minify
kubectl auth can-i get pods
kubectl auth can-i update pods
kubectl auth can-i "*" "*"
```

## Provisioning the EKS Game Application

To set up and deploy the Game application, follow these steps and ensure the necessary tools and configurations are in place.

 - ### Prerequisites

   1. **Terraform**: Install Terraform to manage infrastructure as code. Make sure `tfenv` is installed to easily select the correct Terraform version as specified in the repository settings.
   2. **AWS Access**: Ensure AWS access keys are configured on your local machine with the necessary permissions to deploy the resources.
   3. **Bash**: The provisioning process uses a Bash glue script to automate Terraform and other required actions.

- ### Environment Seup:
  All environment-specific configurations are stored in the `secrets` folder, while the Terraform modules provide a common setup across all environments. Specify the deployment environment (e.g., dev, staging, prod).

- ### Terraform Actions: 
  Choose one of the following actions:
  - **plan**: Previews the changes to be made.
  - **apply**: Executes the changes to create or update resources.
  - **destroy**: Removes the provisioned resources.

- ### Managing Sensitive Data
  Sensitive values, such as API keys and secrets, are stored securely in the secrets folder. Ensure that this folder contains the necessary files in the correct formats. 
  
  Importantly, do not push the secrets folder to GitHub. The secrets folder is provided here only as a reference on how to structure sensitive information. These files should be stored securely in a vault, such as LastPass, or encrypted using a tool like git-crypt to protect sensitive data.

- ### Provisioning Steps

   This application uses an automated provisioning process driven by a Bash script. Simply use the following command to deploy, update, or destroy resources based on the desired environment.

   ```bash
     Syntax ./bin/deploy.sh [Environment] [plan|apply|destroy]
     Get plan state        = ./bin/deploy.sh [Environment] plan [module name]
     Apply single module   = ./bin/deploy.sh dev apply "module.lambda_function"
     Apply enrire stack    = ./bin/deploy.sh dev apply
   ```
