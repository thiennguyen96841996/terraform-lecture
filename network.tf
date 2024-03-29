# ---------------------------------------------
# VPC
# ---------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/20" // IPv4 CIDR ブロック
  instance_tenancy                 = "default"  // テナンシー（"default", "delicated"）
  enable_dns_support               = true // DNS解決
  enable_dns_hostnames             = true // DNSホスト名
  assign_generated_ipv6_cidr_block = false  // IPv6 CIDR ブロック

  // タグ
  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}

# ---------------------------------------------
# Subnet
# ---------------------------------------------
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id  // VPC ID
  availability_zone       = "ap-northeast-1a" // アベイラビリティゾーン
  cidr_block              = "192.168.1.0/24"  // CIDR ブロック
  map_public_ip_on_launch = true  // 自動割り当てIP設定

  // タグ
  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1c"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.3.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.4.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1c"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

# ---------------------------------------------
# Route Table
# ---------------------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id // VPC ID

  // タグ
  tags = {
    Name    = "${var.project}-${var.environment}-public-rt"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_route_table_association" "public_rt_1a" {
  route_table_id = aws_route_table.public_rt.id // ルートテーブルID
  subnet_id      = aws_subnet.public_subnet_1a.id // サブネットID
}

resource "aws_route_table_association" "public_rt_1c" {
  route_table_id = aws_route_table.public_rt.id // ルートテーブルID
  subnet_id      = aws_subnet.public_subnet_1c.id // サブネットID
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id // VPC ID

  // タグ
  tags = {
    Name    = "${var.project}-${var.environment}-private-rt"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_route_table_association" "private_rt_1a" {
  route_table_id = aws_route_table.private_rt.id  // ルートテーブルID
  subnet_id      = aws_subnet.private_subnet_1a.id  // サブネットID
}

resource "aws_route_table_association" "private_rt_1c" {
  route_table_id = aws_route_table.private_rt.id  // ルートテーブルID
  subnet_id      = aws_subnet.private_subnet_1c.id  // サブネットID
}

# ---------------------------------------------
# Internet Gateway
# ---------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id // VPC ID

  // タグ
  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    Project = var.project
    Env     = var.environment
  }
}

// ルート
resource "aws_route" "public_rt_igw_r" {
  route_table_id         = aws_route_table.public_rt.id // ルートテーブルID
  destination_cidr_block = "0.0.0.0/0"  // 送信先
  gateway_id             = aws_internet_gateway.igw.id  // インターネットゲートウェイID
}
