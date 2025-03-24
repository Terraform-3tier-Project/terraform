
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