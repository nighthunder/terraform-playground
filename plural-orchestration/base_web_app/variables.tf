###############################################################################
# VARIABLES #
###############################################################################

# variable "aws_access_key" {
#  type        = string
#  description = "AWS access key"
#  sensitive   = true
#}

#variable "aws_secret_key" {
#  type        = string
#  description = "AWS secret key"
#  sensitive   = true
#}

variable "aws_region" {
  type        = string
  description = "AWS region set up to use resources"
  default     = "us-east-1"
  sensitive   = false
}

variable "aws_app_vpc_cidr" {
  type        = string
  description = "App vpc cidr block"
  sensitive   = false
  default     = "10.0.0.0/16"
}

variable "aws_public_subnets_cidr" {
  type        = list(string)
  description = "CIDRS blocks for public subnets in the VPC"
  sensitive   = false
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "aws_cidr_default" {
  type        = string
  description = "Cidr address 0.0.0.0/0 default"
  sensitive   = false
  default     = "0.0.0.0/0"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
  sensitive   = false
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
  sensitive   = false
}

variable "instance_type" {
  type        = string
  description = "EC2 machine instance type"
  default     = "t2.micro"
  sensitive   = false
}

variable "company" {
  type        = string
  description = "Company name"
  sensitive   = false
  default     = "Datamora"
}

variable "project" {
  type        = string
  description = "Project name"
  sensitive   = false
}

variable "billing_code" {
  type        = string
  description = "The billing code"
  sensitive   = false
  default     = "BA370Y"
}