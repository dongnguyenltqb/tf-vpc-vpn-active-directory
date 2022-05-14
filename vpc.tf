resource "aws_vpc" "tf-vpc" {
  cidr_block = "10.5.0.0/16"
  tags = merge(local.common_tags, {
    Name = "tf-vpc"
  })
}

// Subnet
// 3 public, 3 private
resource "aws_subnet" "tf-1a-public" {
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = "10.5.0.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, {
    Name = "tf-1a-public"
  })
}


resource "aws_subnet" "tf-1a-private" {
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = "10.5.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false
  tags = merge(local.common_tags, {
    Name = "tf-1a-private"
  })
}


resource "aws_subnet" "tf-1b-public" {
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = "10.5.2.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, {
    Name = "tf-1b-public"
  })
}


resource "aws_subnet" "tf-1b-private" {
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = "10.5.3.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = false
  tags = merge(local.common_tags, {
    Name = "tf-1b-private"
  })
}
resource "aws_subnet" "tf-1c-public" {
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = "10.5.4.0/24"
  availability_zone       = "ap-southeast-1c"
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, {
    Name                          = "tf-1c-public"
    "kubernetes.io/role/elb"      = 1
    "kubernetes.io/cluster/basic" = "owned"
  })
}


resource "aws_subnet" "tf-1c-private" {
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = "10.5.5.0/24"
  availability_zone       = "ap-southeast-1c"
  map_public_ip_on_launch = false
  tags = merge(local.common_tags, {
    Name = "tf-1c-private"
  })
}


// Internet gateway
resource "aws_internet_gateway" "tf-igw" {
  vpc_id = aws_vpc.tf-vpc.id

  tags = merge(local.common_tags, {
    Name = "tf-igw"
  })
}


// ElasticIP for NAT
resource "aws_eip" "tf-nat-ip" {
  vpc = true
  tags = merge(local.common_tags, {
    Name = "tf-nat-ip"
  })
}


// Nate gateway
resource "aws_nat_gateway" "tf-nat-gw" {
  allocation_id = aws_eip.tf-nat-ip.id
  subnet_id     = aws_subnet.tf-1a-public.id
  tags = merge(local.common_tags, {
    Name = "tf-nat"
  })
  depends_on = [aws_eip.tf-nat-ip]

}


// Route table for public subnet
// route traffic to internet gateway
resource "aws_route_table" "tf-rtb-public" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-igw.id
  }

  tags = {
    Name = "tf-pub-route"
  }
}



// Route table for private subnet
// route traffic to  NAT gateway
resource "aws_route_table" "tf-rtb-private" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tf-nat-gw.id
  }

  tags = merge(local.common_tags, {
    Name = "tf-private-route"
  })
}

// Set main route is  public route
resource "aws_main_route_table_association" "tf-vpc-rtb-main" {
  vpc_id         = aws_vpc.tf-vpc.id
  route_table_id = aws_route_table.tf-rtb-public.id
}


resource "aws_route_table_association" "tf-vpc-rtb-association-sub-1a-pub" {
  subnet_id      = aws_subnet.tf-1a-public.id
  route_table_id = aws_route_table.tf-rtb-public.id
}

resource "aws_route_table_association" "tf-vpc-rtb-association-sub-1b-pub" {
  subnet_id      = aws_subnet.tf-1b-public.id
  route_table_id = aws_route_table.tf-rtb-public.id
}

resource "aws_route_table_association" "tf-vpc-rtb-association-sub-1c-pub" {
  subnet_id      = aws_subnet.tf-1c-public.id
  route_table_id = aws_route_table.tf-rtb-public.id
}


resource "aws_route_table_association" "tf-vpc-rtb-association-sub-1a-private" {
  subnet_id      = aws_subnet.tf-1a-private.id
  route_table_id = aws_route_table.tf-rtb-private.id
}
resource "aws_route_table_association" "tf-vpc-rtb-association-sub-1b-private" {
  subnet_id      = aws_subnet.tf-1b-private.id
  route_table_id = aws_route_table.tf-rtb-private.id
}


resource "aws_route_table_association" "tf-vpc-rtb-association-sub-1c-private" {
  subnet_id      = aws_subnet.tf-1c-private.id
  route_table_id = aws_route_table.tf-rtb-private.id
}

