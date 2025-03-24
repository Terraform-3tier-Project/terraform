output "alb_dns_name" {
  description = "DNS name of the backend ALB"
  value       = aws_lb.backend_alb.dns_name
}

output "target_group_arn" {
  description = "ARN of the backend Target Group"
  value       = aws_lb_target_group.backend_tg.arn
}
