variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "ec2_sg_ids" {
  description = "List of EC2 security group IDs"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for ASG"
  type        = list(string)
}

variable "target_group_arns" {
  description = "List of Target Group ARNs to attach to the ASG"
  type        = list(string)
}


variable "instance_profile_name" {
  description = "IAM instance profile name"
  type        = string
}

variable "instance_name" {
  description = "Tag name for EC2 instances"
  type        = string
}

variable "asg_name_prefix" {
  description = "Prefix for Auto Scaling Group name"
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
}

variable "user_data" {
  description = "User data script for EC2"
  type        = string
}
