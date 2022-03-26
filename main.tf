resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr
  instance_tenancy = "default"

  tags = {
    Name = var.project
    project = var.project
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.project
    project = var.project

  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
      }

  tags = {
    Name = var.project
    project = var.project
  }
}

resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr,3, 0)
  availability_zone       = data.aws_availability_zones.az.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public"
    project = var.project
  }
}


resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr,3, 1)
  availability_zone       = data.aws_availability_zones.az.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public"
    project = var.project
  }
}


resource "aws_subnet" "public3" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr,3, 2)
  availability_zone       = data.aws_availability_zones.az.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-public"
    project = var.project
  }
}



resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_rtb.id
}


resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_rtb.id
}


resource "aws_route_table_association" "public3" {
  subnet_id      = aws_subnet.public3.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_eip" "nat" {

  vpc      = true
  tags = {
    Name    = "${var.project}-nat-gw"
    project = var.project
  }
}



resource "aws_nat_gateway" "nat" {
    
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name    = "${var.project}-nat"
    project = var.project
  }

  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_route_table" "private" {
    
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name    = "${var.project}-private"
    project = var.project
  }
}

resource "aws_subnet" "private1" {
    
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr,3, 3)
  availability_zone       = data.aws_availability_zones.az.names[0]
  map_public_ip_on_launch = false
  tags = {
    Name    = "${var.project}-private1"
    project = var.project
  }
}


resource "aws_subnet" "private2" {
    
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr,3, 4)
  availability_zone       = data.aws_availability_zones.az.names[1]
  map_public_ip_on_launch = false
  tags = {
    Name    = "${var.project}-private2"
    project = var.project
  }
}


resource "aws_subnet" "private3" {
    
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr,3, 5)
  availability_zone       = data.aws_availability_zones.az.names[2]
  map_public_ip_on_launch = false
  tags = {
    Name    = "${var.project}-private3"
    project = var.project
  }
}



resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private.id
}

