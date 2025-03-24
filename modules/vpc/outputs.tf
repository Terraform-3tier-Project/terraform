###########################################################
# modules/vpc/outputs.tf
# - 다른 모듈에서 참조할 수 있는 출력값
###########################################################

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_a_id" {
  value = aws_subnet.public_a.id
}

output "public_subnet_c_id" {
  value = aws_subnet.public_c.id
}

output "frontend_subnet_a_id" {
  value = aws_subnet.frontend_a.id
}

output "frontend_subnet_c_id" {
  value = aws_subnet.frontend_c.id
}

output "backend_subnet_a_id" {
  value = aws_subnet.frontend_a.id
}

output "backend_subnet_c_id" {
  value = aws_subnet.backend_c.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id
  ]
}

output "frontend_subnet_ids" {
  value = [
    aws_subnet.frontend_a.id,
    aws_subnet.frontend_c.id
  ]
}


output "backend_subnet_ids" {
  description = "List of backend subnet IDs"
  value = [
    aws_subnet.backend_a.id,
    aws_subnet.backend_c.id
  ]
}
