
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
