module "aws_frontend" {
  source = "./modules/aws"
}

module "gcp_backend" {
  source = "./modules/gcp"
}
