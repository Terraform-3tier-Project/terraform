# root/variables.tf

variable "vpc_name" {}
variable "vpc_cidr" {}

variable "public_subnet_a_cidr" {}
variable "public_subnet_a_name" {}
variable "public_subnet_c_cidr" {}
variable "public_subnet_c_name" {}

variable "frontend_subnet_a_cidr" {}
variable "frontend_subnet_a_name" {}
variable "frontend_subnet_c_cidr" {}
variable "frontend_subnet_c_name" {}


variable "backend_subnet_a_cidr" {}
variable "backend_subnet_a_name" {}
variable "backend_subnet_c_cidr" {}
variable "backend_subnet_c_name" {}

variable "az_a" {}
variable "az_c" {}

#############################################


variable "key_name" {}
variable "instance_profile_name" {}

variable "backend_ami_id" {}
variable "backend_instance_type" {}
variable "backend_min_size" {}
variable "backend_max_size" {}
variable "backend_desired_capacity" {}


variable "codedeploy_bucket_name" {}