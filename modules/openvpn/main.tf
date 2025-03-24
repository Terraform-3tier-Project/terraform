###########################################################
# modules/openvpn/main.tf
# - Launch EC2 in a public subnet with OpenVPN Access Server AMI
###########################################################

resource "aws_security_group" "openvpn_sg" {
  name   = "OpenVPN-AS-SG"
  vpc_id = var.vpc_id

  # OpenVPN Access Server에서 기본적으로 쓰는 포트들:
  # 943 (웹 UI / admin), 443 (VPN over SSL), 1194 (VPN over UDP), etc.
  ingress {
    from_port   = 943
    to_port     = 943
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH (optional) for direct server management
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "OpenVPN-AS-SG"
  }
}

resource "aws_instance" "openvpn_as" {
  ami                    = var.openvpn_ami_id   # Marketplace AMI ID for OpenVPN Access Server
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.openvpn_sg.id]

  associate_public_ip_address = true  # Public Subnet => public IP for client access
  key_name = var.key_name             # SSH key if needed

  # No user_data needed, because the OpenVPN Access Server AMI 
  # already has the software installed

  tags = {
    Name = "OpenVPN-Access-Server"
  }
}
