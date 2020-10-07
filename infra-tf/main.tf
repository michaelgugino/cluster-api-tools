# Specify the provider and access details
provider "aws" {
  region = var.aws_region
}

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  tags = {
    Name = "mgugino-dev1"
  }
  cidr_block = "10.0.0.0/16"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  tags = {
    Name = "mgugino-dev1"
  }
  vpc_id = aws_vpc.default.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Create a subnet to launch our instances into
resource "aws_subnet" "default" {
  tags = {
    Name = "mgugino-dev1"
  }
  availability_zone = "us-east-1c"
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "mgugino-dev1"
  description = "Used in the terraform"
  vpc_id      = aws_vpc.default.id

  # access from anywhere
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "mgugino-dev1" {

  tags = {
    Name = "mgugino-dev1"
  }

  instance_type = "m5d.2xlarge"

#  root_block_device {
#    volume_type = "gp2"
#    volume_size = 60
#  }

  # Lookup the correct AMI based on the region
  # we specified
  ami = lookup(var.aws_amis, var.aws_region)

  # The name of our SSH keypair we created above.
  key_name = var.key_name

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = aws_subnet.default.id

}
resource "aws_instance" "mgugino-dev2" {

  tags = {
    Name = "mgugino-dev2"
  }

  instance_type = "m5d.2xlarge"

#  root_block_device {
#    volume_type = "gp2"
#    volume_size = 60
#  }

  # Lookup the correct AMI based on the region
  # we specified
  ami = lookup(var.fedora_ami, var.aws_region)

  # The name of our SSH keypair we created above.
  key_name = var.key_name

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = aws_subnet.default.id

}

