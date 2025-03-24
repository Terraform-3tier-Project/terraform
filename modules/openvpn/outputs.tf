###########################################################
# modules/openvpn/outputs.tf
###########################################################

output "openvpn_public_ip" {
  description = "Public IP of the OpenVPN Access Server"
  value       = aws_instance.openvpn_as.public_ip
}

output "openvpn_instance_id" {
  description = "EC2 Instance ID for OpenVPN AS"
  value       = aws_instance.openvpn_as.id
}

output "security_group_id" {
  description = "The security group ID for OpenVPN"
  value       = aws_security_group.openvpn_sg.id
}
