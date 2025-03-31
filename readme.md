# 🚀 Automated Multi-Cloud Deployment with Terraform, AWS, and GCP

This project automates the deployment of cloud infrastructure across **AWS** and **GCP** using **Terraform** and **GitHub Actions**. The setup enables Infrastructure as Code (IaC) for seamless cloud resource provisioning.

---

## **📌 Features**
✅ Deploy an **EC2 instance** on AWS  
✅ Deploy a **Cloud Run service** on GCP  
✅ Automate deployments using **GitHub Actions**  
✅ Infrastructure managed with **Terraform**  

---

## **⚙️ Prerequisites**
Ensure you have the following installed:
- **Terraform CLI** → [Installation Guide](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- **AWS CLI** → [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- **Google Cloud SDK** → [Installation Guide](https://cloud.google.com/sdk/docs/install)
- **GitHub Account** → To store Terraform configurations and run GitHub Actions

---

## **🛠 Step 1: Configure AWS Credentials**
To authenticate with AWS, set up your AWS CLI:
```bash
aws configure
```
Provide:
- **AWS Access Key ID**: `<Your-AWS-Access-Key-ID>`
- **AWS Secret Access Key**: `<Your-AWS-Secret-Access-Key>`
- **Default region**: `us-east-1` (or any other region)
- **Output format**: `json`

✅ **Verify AWS Authentication:**
```bash
aws sts get-caller-identity
```

---

## **🛠 Step 2: Configure GCP Credentials**
1. **Create a GCP Service Account**:
   - Go to **Google Cloud Console** → IAM & Admin → Service Accounts.
   - Create a new service account with **roles**:
     - `Cloud Run Admin`
     - `Compute Admin`
     - `Viewer`
   - Generate a **JSON Key** file.

2. **Authenticate Locally**:
```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
gcloud config set project <your-gcp-project-id>
```

✅ **Verify GCP Authentication:**
```bash
gcloud auth list
```

---

## **🔑 Step 3: Store Credentials in GitHub Secrets**
To enable GitHub Actions to access AWS and GCP, store the credentials securely.

### **Add the following GitHub Secrets**:
| Secret Name                 | Value (Replace with your actual values) |
|-----------------------------|-----------------------------------------|
| `AWS_ACCESS_KEY_ID`         | Your AWS Access Key ID                 |
| `AWS_SECRET_ACCESS_KEY`     | Your AWS Secret Access Key             |
| `GCP_PROJECT_ID`            | Your GCP Project ID                    |
| `GCP_SERVICE_ACCOUNT_KEY`   | JSON content of the service account key |

✅ **How to add secrets in GitHub**:
- Go to **GitHub Repository → Settings → Secrets and Variables → Actions**  
- Click **New Repository Secret** and add the values.

---

## **📝 Step 4: Terraform Configuration**

### **`providers.tf`** – Define AWS & GCP Providers
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "google" {
  project     = var.gcp_project_id
  region      = "us-central1"
  credentials = file(var.gcp_credentials_file)
}

variable "gcp_project_id" {}
variable "gcp_credentials_file" {}
```

### **`aws_instance.tf`** – Deploy EC2 on AWS
```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2
  instance_type = "t2.micro"

  tags = {
    Name = "AWS-Web-Instance"
  }
}
```

### **`gcp_cloud_run.tf`** – Deploy Cloud Run on GCP
```hcl
resource "google_cloud_run_service" "api" {
  name     = "my-api-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
```

---

## **⚡ Step 5: Automate Deployment with GitHub Actions**
Create a workflow file: `.github/workflows/terraform-deployment.yml`
```yaml
name: Multi-Cloud Terraform Deployment

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Repository
      uses: actions/checkout@v2

    - name: Set up Terraform
      uses: hashicorp/setup-terraform@v2

    - name: Configure AWS Credentials
      run: aws configure set aws_access_key_id ${{ secrets.AWS_ACCESS_KEY_ID }} && aws configure set aws_secret_access_key ${{ secrets.AWS_SECRET_ACCESS_KEY }}

    - name: Authenticate with GCP
      run: |
        echo "${{ secrets.GCP_SERVICE_ACCOUNT_KEY }}" > /tmp/gcp-key.json
        gcloud auth activate-service-account --key-file=/tmp/gcp-key.json
        gcloud config set project ${{ secrets.GCP_PROJECT_ID }}

    - name: Run Terraform Deployment
      run: ./deploy.sh
```

---

## **🚀 Step 6: Running the Deployment**
### **1️⃣ Run Locally**
Make the script executable:
```bash
chmod +x deploy.sh
./deploy.sh
```

### **2️⃣ Trigger Deployment via GitHub Actions**
Push the code to `main`:
```bash
git add .
git commit -m "Deploy multi-cloud infrastructure"
git push origin main
```

---

## **📂 Project Structure**
```
.
├── .github/
│   └── workflows/
│       └── terraform-deployment.yml
├── deploy.sh
├── providers.tf
├── aws_instance.tf
├── gcp_cloud_run.tf
├── README.md
```

---

## **🌐 License**
This project is licensed under the **MIT License**.

---

## **📱 Contact**
For any issues, open an **issue** on GitHub.

