resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "main_vpc"
    }
}

# Public Subnets
resource "aws_subnet" "public_1" {
 vpc_id = aws_vpc.main.id
 cidr_block = "10.0.0.0/20"

 tags = {
   Name = "public-1-subnet"
 }
}

resource "aws_subnet" "public_2" {
 vpc_id = aws_vpc.main.id
 cidr_block = "10.0.16.0/20"
 
 tags = {
   Name = "public-2-subnet"
 }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.main.id
 tags = {
   Name = "my-igw"
 }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
 vpc_id = aws_vpc.main.id

 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
 }
 
 tags = {
   Name = "public-route-table"
 }
}

locals {
  subnet_ids = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

# Route Table Associations
resource "aws_route_table_association" "public_assoc" {
  for_each = toset(local.subnet_ids)
  subnet_id = each.value.id
  route_table_id = aws_route_table.public_rt.id
}