terraform {
  backend "s3" {
    bucket       = "prod-infra-state.bucket"
    key          = "prod/terraform.tfstate"
    region       = "us-west-1"
    use_lockfile = true
    encrypt      = true
  }
}