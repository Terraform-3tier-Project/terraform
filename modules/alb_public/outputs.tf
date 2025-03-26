output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "backend_target_group_arn" {
  value = aws_lb_target_group.this.arn
}
