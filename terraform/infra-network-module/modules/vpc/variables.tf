variable "name" {
  type        = string
  description = "Base name used for network resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment name."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
}

variable "azs" {
  type        = list(string)
  description = "Availability zones to deploy the VPC subnets into."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets."
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets."
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to all VPC resources."
  default     = {}
}
