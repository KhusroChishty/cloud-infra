terraform {
  backend "s3" {
    bucket       = "prod-infra-bucket"
    key          = "backend-infra-prod/terraform.tfstate"
    region       = "us-west-1"
    use_lockfile = true
    encrypt      = true
  }
}