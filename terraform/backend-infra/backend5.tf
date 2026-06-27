terraform {
  backend "s3" {
    bucket       = "name"
    key          = "prod/terraform.tfstate"
    region       = "us-west-2"
    use_lockfile = true
    encrypt      = true
  }
}