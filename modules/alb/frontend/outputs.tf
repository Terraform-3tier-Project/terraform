output "alb_dns_name" {
  description = "DNS name of the frontend ALB"
  value       = aws_lb.frontend_alb.dns_name
}

output "target_group_arn" {
  description = "ARN of the frontend Target Group"
  value       = aws_lb_target_group.frontend_tg.arn
}
