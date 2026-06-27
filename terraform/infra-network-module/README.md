# infra-network-module

This folder contains a production-ready Terraform setup for creating a VPC in AWS `us-west-2` using a reusable module.

## Structure

- `versions.tf` - Terraform version and provider requirements.
- `providers.tf` - AWS provider configuration for the root module.
- `variables.tf` - Root module input variables for environment, VPC CIDR, AZs, subnet CIDRs, and tags.
- `main.tf` - Instantiates the reusable VPC module from `./modules/vpc`.
- `outputs.tf` - Exposes the created VPC and subnet IDs.
- `modules/vpc/` - The reusable VPC module implementation.
  - `variables.tf` - Module-specific inputs.
  - `main.tf` - Creates the VPC, subnets, NAT gateways, route tables, and associations.
  - `outputs.tf` - Exports VPC and subnet IDs.

## How it works

1. The root module receives environment-level inputs and forwards them to the VPC module.
2. The `modules/vpc` module creates:
   - `aws_vpc`
   - `aws_internet_gateway`
   - 3 public subnets
   - 3 private subnets
   - Elastic IPs and NAT gateways for private subnet internet access
   - Public route table with internet gateway route
   - Private route table with NAT gateway routes
3. The module outputs VPC and subnet IDs so other modules can consume the network resources.

## Usage

From `terraform/infra-network-module`:

```bash
terraform init
terraform plan
terraform apply
```

### Example variable overrides

You can set variables with a `.tfvars` file or environment variables.

`terraform.tfvars` example:

```hcl
region              = "us-west-2"
environment         = "production"
name                = "prod-app"
vpc_cidr            = "10.0.0.0/16"
azs                 = ["us-west-2a", "us-west-2b", "us-west-2c"]
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
tags = {
  Project     = "production-app"
  ManagedBy   = "terraform"
}
```

## Notes

- Root and module files with the same names (for example, `main.tf` and `variables.tf`) are normal because the root module and child module are separate Terraform scopes.
- If you want remote state, add a `backend.tf` in this folder.
