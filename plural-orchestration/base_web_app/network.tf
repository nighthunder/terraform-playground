
############################################################################################################
# DATA
############################################################################################################

data "aws_availability_zones" "available" {
  state = "available"

}

#############################################################################################################
# RESOURCES
############################################################################################################

# NETWORKING
resource "aws_vpc" "app" {
  cidr_block           = var.aws_app_vpc_cidr
  enable_dns_hostnames = true

  tags = local.common_tags
}

resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id

  tags = local.common_tags
}

resource "aws_subnet" "public_subnet1" {
  cidr_block              = var.aws_public_subnets_cidr[0]
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags                    = local.common_tags
}

resource "aws_subnet" "public_subnet2" {
  cidr_block              = var.aws_public_subnets_cidr[1]
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags                    = local.common_tags
}

# ROUTING #

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = var.aws_cidr_default
    gateway_id = aws_internet_gateway.app.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "app_subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table_association" "app_subnet2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.app.id
}

# SECURITY GROUPS
# Nginx security GROUPS
resource "aws_security_group" "nginx1_sg" {
  name   = "nginx_sg1"
  vpc_id = aws_vpc.app.id

  # HTTPS access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.aws_app_vpc_cidr]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.aws_cidr_default]
  }

  tags = local.common_tags
}

resource "aws_security_group" "nginx_alb_sg" {
  name   = "nginx_alb_sg"
  vpc_id = aws_vpc.app.id

  # HTTPS access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.aws_cidr_default]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.aws_cidr_default]
  }

  tags = local.common_tags
}





