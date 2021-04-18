# Create a new instance of the latest Ubuntu 20.04 on an
# t3.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_default_vpc" "awslab-vpc" {
    tags = {
        Name = "awslab-vpc"
    }
}
resource "aws_vpc" "awslab-vpc" {
    cidr_block = "172.16.0.0/16"
      instance_tenancy = "default"

    tags = {
        Name = "main"
    }
}

resource "aws_default_subnet" "awslab-subnet-public" {
    availability_zone = "us-east-1a"
    cidr_block = "172.16.1.0/24"

  tags = {
    Name = "Public subnet for COCUS challenge"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}


resource "aws_default_security_group" "sg-app" {
  vpc_id = aws_default_vpc.default.id

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

/* resource "aws_instance" "k8sprod" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.large"
  key_name = "dos_key"
  subnet_id     = aws_default_subnet.default_az1.id
  user_data = file("./userdata/bootstrap")
  tags = {
    Name = "k8sprod"
  }
} */