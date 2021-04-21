# Create a new instance of the latest Ubuntu 20.04 on an
# t3.micro node with an AWS Tag naming it "HelloWorld"
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

resource "aws_vpc" "awslab-vpc" {
    cidr_block = "172.16.0.0/16"
      instance_tenancy = "default"

    tags = {
        Name = "awslab-vpc"
    }
}

resource "aws_subnet" "awslab-subnet-public" {
    vpc_id = aws_vpc.awslab-vpc.id
    availability_zone = var.availability_zone
    cidr_block = "172.16.1.0/24"

  tags = {
    Name = "Public subnet for COCUS SRE challenge"
  }
}

resource "aws_subnet" "awslab-subnet-private" {
    vpc_id = aws_vpc.awslab-vpc.id
    availability_zone = var.availability_zone
    cidr_block = "172.16.2.0/24"

  tags = {
    Name = "Private subnet for COCUS SRE challenge"
  }
}

resource "aws_instance" "webserver" {
  ami           = "ami-023c8dbf8268fb3ca"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.awslab-subnet-public.id

  tags = {
    Name = "webserver"
  }
}


/* 

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}


resource "aws_default_security_group" "sg-public" {
    vpc_id = aws_vpc.awslab.id

    ingress {
        protocol  = -1
        self      = true
        from_port = 0
        to_port   = 0
    }

    # SSH access
    ingress {
        protocol  = 6
        from_port = 22
        to_port   = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    # SSH access
    ingress {
        protocol  = 6
        from_port = 22
        to_port   = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

}


resource "aws_key_pair" "dos_key" {
  key_name   = "dos_key"
  public_key = file(var.aws_key_pair)
}

resource "aws_instance" "webserver" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  key_name      = "dos_key"
  subnet_id     = aws_default_subnet.default_az1.id
  user_data = file("./userdata/bootstrap")

  tags = {
    Name = "k8sdev"
  }
}

resource "aws_instance" "k8sprod" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.large"
  key_name = "dos_key"
  subnet_id     = aws_default_subnet.default_az1.id
  user_data = file("./userdata/bootstrap")
  tags = {
    Name = "k8sprod"
  }
} 

*/