###########################################################
# modules/vpc/vpc.tf
# - VPC, 서브넷, IGW, NAT, 라우트 테이블 등을 정의
###########################################################

# VPC 생성
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr            # 예: "10.0.0.0/16"
  enable_dns_hostnames = true                    # VPC 내부 DNS 사용
  tags = {
    Name = var.vpc_name                          # "MyVPC"
  }
}

# 인터넷 게이트웨이(IGW): VPC와 연결, 퍼블릭 서브넷 인터넷 액세스 제공
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Public Subnet A
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_a_cidr   # ex) "10.0.1.0/24"
  availability_zone       = var.az_a
  map_public_ip_on_launch = true   # 인스턴스에 퍼블릭 IP 자동 할당
  tags = {
    Name = var.public_subnet_a_name
  }
}

# Public Subnet C
resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_c_cidr   # ex) "10.0.2.0/24"
  availability_zone       = var.az_c
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnet_c_name
  }
}

# frontend Subnet A
resource "aws_subnet" "frontend_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.frontend_subnet_a_cidr  # ex) "10.0.101.0/24"
  availability_zone = var.az_a
  tags = {
    Name = var.frontend_subnet_a_name
  }
}

# frontend Subnet C
resource "aws_subnet" "frontend_c" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.frontend_subnet_c_cidr  # ex) "10.0.102.0/24"
  availability_zone = var.az_c
  tags = {
    Name = var.frontend_subnet_c_name
  }
}

# backend Subnet A
resource "aws_subnet" "backend_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.backend_subnet_a_cidr  # ex) "10.0.101.0/24"
  availability_zone = var.az_a
  tags = {
    Name = var.backend_subnet_a_name
  }
}

# backend Subnet C
resource "aws_subnet" "backend_c" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.backend_subnet_c_cidr  # ex) "10.0.102.0/24"
  availability_zone = var.az_c
  tags = {
    Name = var.backend_subnet_c_name
  }
}


# NAT Gateway용 Elastic IP
resource "aws_eip" "nat" {
  vpc = true
}

# NAT Gateway (Public Subnet A)
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id
  tags = {
    Name = "${var.vpc_name}-nat"
  }
}

#####################

# Public Route Table (인터넷 게이트웨이 경유)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"               # 모든 트래픽
    gateway_id = aws_internet_gateway.this.id  # IGW 경유
  }
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

# Public Subnet A 라우트 테이블 연관
resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

# Public Subnet C 라우트 테이블 연관
resource "aws_route_table_association" "public_c_assoc" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public_rt.id
}

#####################
# Frontend Route Table (NAT Gateway 경유)
resource "aws_route_table" "frontend_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"               # 모든 트래픽
    nat_gateway_id = aws_nat_gateway.this.id   # NAT 게이트웨이 경유
  }
  tags = {
    Name = "${var.vpc_name}-frontend-rt"
  }
}

# Frontend Subnet A 라우트 테이블 연관
resource "aws_route_table_association" "frontend_a_assoc" {
  subnet_id      = aws_subnet.frontend_a.id
  route_table_id = aws_route_table.frontend_rt.id
}

# Frontend Subnet C 라우트 테이블 연관
resource "aws_route_table_association" "frontend_c_assoc" {
  subnet_id      = aws_subnet.frontend_c.id
  route_table_id = aws_route_table.frontend_rt.id
}
#####################


# Backend Route Table (NAT Gateway 경유)
resource "aws_route_table" "backend_rt" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"               # 모든 트래픽
    nat_gateway_id = aws_nat_gateway.this.id   # NAT 게이트웨이 경유
  }
  tags = {
    Name = "${var.vpc_name}-backend-rt"
  }
}

# Backend Subnet A 라우트 테이블 연관
resource "aws_route_table_association" "backend_a_assoc" {
  subnet_id      = aws_subnet.backend_a.id
  route_table_id = aws_route_table.backend_rt.id
}

# Private Subnet C 라우트 테이블 연관
resource "aws_route_table_association" "backend_c_assoc" {
  subnet_id      = aws_subnet.backend_c.id
  route_table_id = aws_route_table.backend_rt.id
}