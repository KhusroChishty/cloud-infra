terraform {
    backend "s3" {
        bucket = "infra-bucket-prod"
        key = "prod/terraform.tfstate"
        region = "us-west-1"
        use_lockfile = true
        encrypt = true
    }
}