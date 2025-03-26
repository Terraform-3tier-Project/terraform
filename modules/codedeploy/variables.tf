variable "app_name" {
  description = "CodeDeploy Application Name"
  type        = string
}

variable "deployment_group_name" {
  description = "Deployment Group Name"
  type        = string
}

variable "service_role_name" {
  description = "IAM Role name for CodeDeploy"
  type        = string
}

variable "ec2_tag_key" {
  description = "EC2 tag key to target"
  type        = string
}

variable "ec2_tag_value" {
  description = "EC2 tag value to target"
  type        = string
}
