variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "bucket_arn" {
  description = "S3 bucket ARN"
  type        = string
}

variable "bucket_regional_domain_name" {
  description = "S3 regional domain name"
  type        = string
}

variable "folder_path" {
  description = "Prefix path inside the bucket (e.g. 'frontend/')"
  type        = string
}


variable "backend_alb_dns_name" {
  type = string
}
