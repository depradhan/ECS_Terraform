# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr # Specifies the IP range for the VPC
  enable_dns_support   = true         # Enables DNS support in the VPC
  enable_dns_hostnames = true         # Enables DNS hostnames in the VPC
  tags = {
    Name = "MyVPC" # Adds a Name tag to the VPC for easier identification
  }
}

# Create Internet Gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id # Associates the Internet Gateway with our VPC

  tags = {
    Name = "MyVPC-IGW" # Adds a Name tag to the Internet Gateway
  }
}

# Create Public Subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id      # Associates the subnet with our VPC
  cidr_block        = var.public_subnet_1_cidr # Specifies the IP range for this subnet
  availability_zone = "eu-west-3a"             # Specifies the AZ for this subnet (Change based on your region)

  tags = {
    Name = "Public Subnet 1" # Adds a Name tag to the subnet
  }
}

# Create Public Subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id      # Associates the subnet with our VPC
  cidr_block        = var.public_subnet_2_cidr # Specifies the IP range for this subnet
  availability_zone = "eu-west-3b"             # Specifies the AZ for this subnet (Change based on your region)

  tags = {
    Name = "Public Subnet 2" # Adds a Name tag to the subnet
  }
}

# Create Private Subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id       # Associates the subnet with our VPC
  cidr_block        = var.private_subnet_1_cidr # Specifies the IP range for this subnet
  availability_zone = "eu-west-3a"              # Specifies the AZ for this subnet (Change based on your region)

  tags = {
    Name = "Private Subnet 1" # Adds a Name tag to the subnet
  }
}

# Create Private Subnet 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id       # Associates the subnet with our VPC
  cidr_block        = var.private_subnet_2_cidr # Specifies the IP range for this subnet
  availability_zone = "eu-west-3b"              # Specifies the AZ for this subnet (Change based on your region)

  tags = {
    Name = "Private Subnet 2" # Adds a Name tag to the subnet
  }
}

# Create Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id # Associates the route table with our VPC

  route {
    cidr_block = "0.0.0.0/0"                 # Route all IPv4 traffic
    gateway_id = aws_internet_gateway.igw.id # to the Internet Gateway
  }

  tags = {
    Name = "Public Route Table" # Adds a Name tag to the route table
  }
}

# Associate Public Route Table with Public Subnets
resource "aws_route_table_association" "public_rt_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id # Associates the route table
  route_table_id = aws_route_table.public_rt.id  # with Public Subnet 1
}

resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id # Associates the route table
  route_table_id = aws_route_table.public_rt.id  # with Public Subnet 2
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc" # Allocates the Elastic IP in the VPC
}

# Create NAT Gateway for Private Subnets
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id            # Associates the Elastic IP with the NAT Gateway
  subnet_id     = aws_subnet.public_subnet_1.id # Places the NAT Gateway in Public Subnet 1

  tags = {
    Name = "MyVPC-NAT-Gateway" # Adds a Name tag to the NAT Gateway
  }
}

# Create Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id # Associates the route table with our VPC

  route {
    cidr_block     = "0.0.0.0/0"               # Route all IPv4 traffic
    nat_gateway_id = aws_nat_gateway.nat_gw.id # to the NAT Gateway
  }

  tags = {
    Name = "Private Route Table" # Adds a Name tag to the route table
  }
}

# Associate Private Route Table with Private Subnets
resource "aws_route_table_association" "private_rt_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id # Associates the route table
  route_table_id = aws_route_table.private_rt.id  # with Private Subnet 1
}

resource "aws_route_table_association" "private_rt_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id # Associates the route table
  route_table_id = aws_route_table.private_rt.id  # with Private Subnet 2
}
