provider "aws" {
  region     = "us-east-1"
  profile  = "defult" 
}

#deploy vpc with tag 

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "main"
    Environment = "terraformChamps"
    Owner       = "mfathy"
  }
}
#deploy public subnet 
resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
   availability_zone = "us-east-1a"
  tags = {  
  Name = "subnet_1"
  Environment = "terraformChamps"
  Owner       = "mfathy"
  }
}
# Create Internet Gateway
resource "aws_internet_gateway" "myige" {
  vpc_id = aws_vpc.main.id 

  tags = {
    Name = "myige"
    Environment = "terraformChamps"
    Owner       = "mfathy"
  }
}

# deploy route table
resource "aws_route_table" "MyRouteTable" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myige.id
  }

  tags = {
    Name = "MyRouteTable"
    Environment = "terraformChamps"
    Owner       = "mfathy"
  }
}

# deploy table association
resource "aws_route_table_association" "subnet_association_public" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.MyRouteTable.id
}