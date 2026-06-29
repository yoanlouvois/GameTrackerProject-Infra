variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR du VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones utilisées"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR des subnets publics"
}

variable "private_app_subnet_cidrs" {
  type        = list(string)
  description = "CIDR des subnets privés APP"
}

variable "private_data_subnet_cidrs" {
  type        = list(string)
  description = "CIDR des subnets privés DATA"
}