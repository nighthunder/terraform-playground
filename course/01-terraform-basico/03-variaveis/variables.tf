variable "environment" {
  type        = string
  description = ""
}

variable "aws_region" {
  type        = string
  description = "region"
  default = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "profile"
  default = "default"
}

variable "instance_ami" {
  type        = string
  description = "ami-0dfcb1ef8550277af"
}

variable "instance_type" {
  type        = string
  description = "t3.micro"
}

variable "instance_tags" {
  type        = map(string)
  description = "Meu ubuntinho"
  default = {
    Name    = "Ubuntu"
    Project = "Curso AWS com Terraform"
  }
}
