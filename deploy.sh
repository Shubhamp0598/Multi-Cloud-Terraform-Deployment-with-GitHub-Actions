#!/bin/bash

# Exit on error
set -e

# Variables
AWS_PROFILE="default"
GCP_PROJECT_ID="your-gcp-project-id"
GCP_CREDENTIALS_FILE="/path/to/service-account.json"
TERRAFORM_DIR="$(pwd)"

check_dependencies() {
  echo "Checking dependencies..."

  if ! command -v terraform &> /dev/null; then
    echo "Terraform not found. Please install Terraform."
    exit 1
  fi

  if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found. Please install AWS CLI."
    exit 1
  fi

  if ! command -v gcloud &> /dev/null; then
    echo "GCP SDK not found. Please install GCP SDK."
    exit 1
  fi

  echo "All dependencies are installed!"
}

configure_aws() {
  echo "Configuring AWS..."

  aws configure list-profiles | grep "$AWS_PROFILE" &> /dev/null || {
    echo "AWS profile $AWS_PROFILE not configured. Run 'aws configure' first."
    exit 1
  }

  echo "AWS is configured!"
}

configure_gcp() {
  echo "Configuring GCP..."

  if [ ! -f "$GCP_CREDENTIALS_FILE" ]; then
    echo "GCP credentials file not found: $GCP_CREDENTIALS_FILE"
    exit 1
  fi

  export GOOGLE_APPLICATION_CREDENTIALS="$GCP_CREDENTIALS_FILE"
  gcloud auth activate-service-account --key-file="$GCP_CREDENTIALS_FILE"
  gcloud config set project "$GCP_PROJECT_ID"

  echo "GCP is configured!"
}

terraform_init_apply() {
  echo "Initializing Terraform..."
  cd "$TERRAFORM_DIR"

  terraform init
  terraform validate

  echo "Planning Terraform deployment..."
  terraform plan -out=tfplan

  echo "Applying Terraform deployment..."
  terraform apply tfplan

  echo "Terraform deployment completed!"
}

cleanup() {
  echo "Cleaning up..."
  rm -f tfplan
}

echo "Starting Multi-Cloud Deployment Script..."

check_dependencies
configure_aws
configure_gcp
terraform_init_apply
cleanup

echo "Multi-Cloud Deployment Completed Successfully!"
