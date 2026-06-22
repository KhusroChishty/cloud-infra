terraform {
    backend "s3" {
        bucket = "prod-state-infra-bucket"
        key = "prod/terraform.tfstate"
        region = "us-west-1"
        lock_key = true
        encrypt = true
    }

    tags = {
        Enviorment = "prod"
    }
}


# Terraform’s current S3 backend docs say S3 state locking is enabled with use_lockfile = true, not lock_key. Source: HashiCorp Terraform S3 backend docs.