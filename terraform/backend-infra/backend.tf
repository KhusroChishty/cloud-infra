terraform {
  backend "s3" {
    bucket       = "prod-state-infra-bucket"
    key          = "backend-infra/terraform.tfstate"
    region       = "us-west-1"
    use_lockfile = true
    encrypt      = true
  }
}
