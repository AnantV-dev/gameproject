variable "region" {
  description = "default region"
}

variable "access" {
  description = "access"
}

variable "secret" {
  description = "secret"
}

variable "environment" {
  description = "The Deployment environment"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnet1_cidr" {
  description = "The CIDR block for the public subnet"
}

variable "public_subnet2_cidr" {
  description = "The CIDR block for the public subnet"
}

variable "private_subnet1_cidr" {
  description = "The CIDR block for the private subnet"
}

variable "private_subnet2_cidr" {
  description = "The CIDR block for the private subnet"
}

variable "allowed_cidr_blocks" {
  description = "The allowed CIDR block for the alb"
}
