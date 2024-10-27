provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

provider "google" {
  project = "your-gcp-project-id"
  region  = "us-central1"
  credentials = file(var.gcp_credentials_file)
}

variable "gcp_credentials_file" {
  default = "/path/to/service-account.json"
}
