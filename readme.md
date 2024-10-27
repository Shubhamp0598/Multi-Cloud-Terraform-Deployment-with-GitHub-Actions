# Multi-Cloud Terraform Deployment with GitHub Actions

This project automates the deployment of infrastructure across **AWS** and **GCP** using **Terraform** and **GitHub Actions**. The setup ensures smooth provisioning of cloud resources using Infrastructure as Code (IaC) principles.

---

## **Overview**
This project demonstrates:
- **AWS**: Deploys an EC2 instance.
- **GCP**: Deploys a Cloud Run service.
- **GitHub Actions**: Automates deployments on push events to the `master` branch.
- **Terraform**: Manages infrastructure configuration and state.

---

## **Prerequisites**
Ensure you have the following:
1. **Terraform**: Installed and configured ([Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)).
2. **AWS CLI**: Installed and configured with an IAM user ([Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)).
3. **GCP SDK**: Installed and configured with a service account ([Guide](https://cloud.google.com/sdk/docs/install)).

---

## **Setup Guide**

### 1. Clone the Repository
```bash
git clone https://github.com/Pranav-Saraswat/Multi-Cloud-Terraform-Deployment-with-GitHub-Actions.git
cd Multi-Cloud-Terraform-Deployment-with-GitHub-Actions

### 2. Configure AWS and GCP Credentials

## AWS

Setup your AWS credentials using the AWS CLI:
```bash
aws configure

## GCP

Download your GCP service account key and export it
```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"


#### need to add more information will add later on this project is in WIP