variable "region" {
  type        = string
  description = "AWS region for the production VPC."
  default     = "us-west-2"
}

variable "environment" {
  type        = string
  description = "Deployment environment name."
  default     = "production"
}

variable "name" {
  type        = string
  description = "Base name used for network resources."
  default     = "prod-app"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones to deploy the VPC subnets into."
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets."
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets."
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to all VPC resources."
  default     = {}
}
