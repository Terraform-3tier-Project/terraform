
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

  backend_subnet_a_cidr = var.backend_subnet_a_cidr
  backend_subnet_a_name = var.backend_subnet_a_name
  backend_subnet_c_cidr = var.backend_subnet_c_cidr
  backend_subnet_c_name = var.backend_subnet_c_name

  az_a = var.az_a
  az_c = var.az_c
}






resource "aws_security_group" "backend_alb_sg" {
  name        = "backend-alb-sg"
  description = "Allow internal access to backend ALB"
  vpc_id      = module.vpc.vpc_id

  # 프론트엔드 인스턴스나 ALB에서 들어오는 트래픽 허용
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 외부 접근 허용
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 또는 CloudFront IP CIDR
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

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [module.openvpn.security_group_id] # ✅ 여기!
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

  # ✅ internal + public ALB 둘 다 연결
  target_group_arns = [
    module.backend_public_alb.backend_target_group_arn
  ]

  instance_profile_name  = var.instance_profile_name
  instance_name          = "backend"
  asg_name_prefix        = "backend-asg-"
  min_size               = var.backend_min_size
  max_size               = var.backend_max_size
  desired_capacity       = var.backend_desired_capacity
  user_data              = filebase64("${path.module}/userdata/backend.sh")
}





module "codedeploy_backend" {
  source = "./modules/codedeploy"

  app_name              = "backend-app"
  deployment_group_name = "backend-deploy-group"
  service_role_name     = "CodeDeployRole"
  ec2_tag_key           = "Name"
  ec2_tag_value         = "backend"
}




module "openvpn" {
  source = "./modules/openvpn"

  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_a_id

  openvpn_ami_id   = "ami-0da165fc7156630d7" 
  key_name         = "keypair-kube-master"
}


module "s3" {
  source      = "./modules/s3"
  bucket_name = var.codedeploy_bucket_name

}


module "cloudfront" {
  source = "./modules/cloudfront"

  bucket_name                 = module.s3.bucket_name
  bucket_arn                  = module.s3.bucket_arn
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  folder_path                 = "frontend/"

  backend_alb_dns_name = module.backend_public_alb.alb_dns_name
}



resource "aws_s3_bucket_policy" "combined_access" {
  bucket = module.s3.bucket_name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # CloudFront용
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action = "s3:GetObject",
        Resource = "${module.s3.bucket_arn}/frontend/*",
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = module.cloudfront.cloudfront_arn
          }
        }
      },

      # GitHub Actions에서 사용하는 IAM 사용자 권한
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::084375578827:user/Sanghyun_Jun"
        },
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ],
        Resource = "${module.s3.bucket_arn}/frontend/*"
      }
    ]
  })
}


module "backend_public_alb" {
  source = "./modules/alb_public"

  name        = "backend-public-alb"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = [
    module.vpc.public_subnet_a_id,
    module.vpc.public_subnet_c_id
  ]
  lb_sg_ids   = [aws_security_group.backend_alb_sg.id]
}


