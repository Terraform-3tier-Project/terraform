variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "lb_sg_ids" {
  description = "List of ALB security group IDs"
  type        = list(string)
}

