
###########################################################
# modules/openvpn/variables.tf
###########################################################

variable "vpc_id" {
  description = "VPC ID for security group"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet ID where OpenVPN AS EC2 is launched"
  type        = string
}

variable "openvpn_ami_id" {
  description = "OpenVPN Access Server AMI ID from AWS Marketplace"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key name (optional) if you need to SSH"
  type        = string
  default     = "keypair-kube-master"
}


