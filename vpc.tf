# VPC
resource "aws_vpc" "jc_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${local.initials}-JC-VPC"
    Environment = "TF spun environment for JC - ${var.firstname} ${var.lastname}"
  }
}

resource "aws_subnet" "jc_public_subnet" {
  vpc_id                  = aws_vpc.jc_vpc.id
  cidr_block              = var.public_subnets_cidr

  tags = {
    Name        = "${local.initials}-JC-Subnet"
    Environment = "TF spun environment for JC - ${var.firstname} ${var.lastname}"
  }
}

resource "aws_internet_gateway" "jc_igw" {
  vpc_id = aws_vpc.jc_vpc.id

  tags = {
    Name        = "${local.initials}-JC-IGW"
    Environment = "TF spun environment for JC - ${var.firstname} ${var.lastname}"
  }
}

resource "aws_route_table" "jc_public_rt" {
  vpc_id = aws_vpc.jc_vpc.id

  tags = {
    Name        = "${local.initials}-JC-RT"
    Environment = "TF spun environment for JC - ${var.firstname} ${var.lastname}"
  }
}

resource "aws_route" "jc_default_route" {
  route_table_id         = aws_route_table.jc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.jc_igw.id
}

resource "aws_route_table_association" "jc_rt_assoc" {
  subnet_id      = aws_subnet.jc_public_subnet.id
  route_table_id = aws_route_table.jc_public_rt.id
}

resource "aws_security_group" "jc_sg" {
  vpc_id      = aws_vpc.jc_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${local.initials}-JC-SG"
    Environment = "TF spun environment for JC - ${var.firstname} ${var.lastname}"
  }
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  description       = "SSH ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jc_sg.id
}

resource "aws_security_group_rule" "allow_rdp" {
  type              = "ingress"
  description       = "SSH ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jc_sg.id
}

resource "aws_security_group_rule" "allow_443" {
  type              = "ingress"
  description       = "443 ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jc_sg.id
}