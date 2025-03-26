###########################################################
# modules/vpc/variables.tf
# - VPC 모듈에서 필요한 변수 정의
###########################################################

variable "vpc_cidr" {
  description = "VPC CIDR (e.g. 10.0.0.0/16)"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for VPC"
  type        = string
}

variable "public_subnet_a_cidr" {
  description = "CIDR for Public Subnet A"
  type        = string
}

variable "public_subnet_a_name" {
  description = "Name tag for Public Subnet A"
  type        = string
}

variable "public_subnet_c_cidr" {
  description = "CIDR for Public Subnet C"
  type        = string
}

variable "public_subnet_c_name" {
  description = "Name tag for Public Subnet C"
  type        = string
}

variable "backend_subnet_a_cidr" {
  description = "CIDR for Private Subnet A"
  type        = string
}

variable "backend_subnet_a_name" {
  description = "Name tag for Private Subnet A"
  type        = string
}

variable "backend_subnet_c_cidr" {
  description = "CIDR for Private Subnet C"
  type        = string
}

variable "backend_subnet_c_name" {
  description = "Name tag for Private Subnet C"
  type        = string
}


variable "az_a" {
  description = "Availability Zone A"
  type        = string
}

variable "az_c" {
  description = "Availability Zone C"
  type        = string
}
