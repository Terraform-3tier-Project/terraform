
provider "aws" {
  region = "ap-northeast-2"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name  = var.vpc_name
  vpc_cidr  = var.vpc_cidr

  public_subnet_a_cidr  = var.public_subnet_a_cidr
  public_subnet_a_name  = var.public_subnet_a_name
  public_subnet_c_cidr  = var.public_subnet_c_cidr
  public_subnet_c_name  = var.public_subnet_c_name

  frontend_subnet_a_cidr = var.frontend_subnet_a_cidr
  frontend_subnet_a_name = var.frontend_subnet_a_name
  frontend_subnet_c_cidr = var.frontend_subnet_c_cidr
  frontend_subnet_c_name = var.frontend_subnet_c_name


  backend_subnet_a_cidr = var.backend_subnet_a_cidr
  backend_subnet_a_name = var.backend_subnet_a_name
  backend_subnet_c_cidr = var.backend_subnet_c_cidr
  backend_subnet_c_name = var.backend_subnet_c_name

  az_a = var.az_a
  az_c = var.az_c
}




resource "aws_security_group" "frontend_alb_sg" {
  name        = "frontend-alb-sg"
  description = "Allow HTTP inbound"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "backend_alb_sg" {
  name        = "backend-alb-sg"
  description = "Allow internal access to backend ALB"
  vpc_id      = module.vpc.vpc_id

  # 프론트엔드 인스턴스나 ALB에서 들어오는 트래픽 허용
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    # cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-alb-sg"
  }
}

module "frontend_alb" {
  source             = "./modules/alb/frontend"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  lb_sg_ids          = [aws_security_group.frontend_alb_sg.id]
}

module "backend_alb" {
  source             = "./modules/alb/backend"
  vpc_id             = module.vpc.vpc_id
  frontend_subnet_ids  = module.vpc.frontend_subnet_ids
  lb_sg_ids          = [aws_security_group.backend_alb_sg.id]
}




###################
resource "aws_security_group" "frontend_ec2_sg" {
  name        = "frontend-ec2-sg"
  description = "Allow HTTP from ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP from ALB SG"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.frontend_alb_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend-ec2-sg"
  }
}


module "frontend_asg" {
  source = "./modules/autoscaling"

  ami_id                 = var.frontend_ami_id
  instance_type          = var.frontend_instance_type
  key_name               = var.key_name
  ec2_sg_ids             = [aws_security_group.frontend_ec2_sg.id]
  subnet_ids             = module.vpc.frontend_subnet_ids
  target_group_arn       = module.frontend_alb.frontend_target_group_arn
  instance_profile_name  = var.instance_profile_name
  instance_name          = "frontend"
  asg_name_prefix        = "frontend-asg-"
  min_size               = var.frontend_min_size
  max_size               = var.frontend_max_size
  desired_capacity       = var.frontend_desired_capacity
  user_data              = filebase64("${path.module}/userdata/frontend.sh")
}



resource "aws_security_group" "backend_ec2_sg" {
  name        = "backend-ec2-sg"
  description = "Allow HTTP from backend ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow 3000 from backend ALB SG"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_alb_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-ec2-sg"
  }
}

module "backend_asg" {
  source = "./modules/autoscaling"

  ami_id                 = var.backend_ami_id
  instance_type          = var.backend_instance_type
  key_name               = var.key_name
  ec2_sg_ids             = [aws_security_group.backend_ec2_sg.id]
  subnet_ids             = module.vpc.backend_subnet_ids
  target_group_arn       = module.backend_alb.backend_target_group_arn
  instance_profile_name  = var.instance_profile_name
  instance_name          = "backend"
  asg_name_prefix        = "backend-asg-"
  min_size               = var.backend_min_size
  max_size               = var.backend_max_size
  desired_capacity       = var.backend_desired_capacity
  user_data              = filebase64("${path.module}/userdata/backend.sh")
}
