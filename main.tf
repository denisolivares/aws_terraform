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

resource "aws_vpc" "awslab_vpc" {
    cidr_block = "172.16.0.0/16"
    instance_tenancy = "default"

    tags = {
        Name = "awslab_vpc"
    }
}

resource "aws_internet_gateway" "awslab_igw" {
    vpc_id = aws_vpc.awslab_vpc.id

    tags = {
        Name = "awslab_igw"
    }
}

resource "aws_route_table" "awslab_rt_public" {
    vpc_id = aws_vpc.awslab_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.awslab_igw.id
    }

    tags = {
        Name = "rt_public"
    }
}

resource "aws_route_table" "awslab_rt_private" {
    vpc_id = aws_vpc.awslab_vpc.id

    route = []

    tags = {
        Name = "rt_private"
    }
}

resource "aws_route_table_association" "awslab_rta_public" {
    subnet_id      = aws_subnet.awslab_sn_public.id
    route_table_id = aws_route_table.awslab_rt_public.id
}

resource "aws_route_table_association" "awslab_rta_private" {
    subnet_id      = aws_subnet.awslab_sn_private.id
    route_table_id = aws_route_table.awslab_rt_private.id
}

resource "aws_subnet" "awslab_sn_public" {
    vpc_id = aws_vpc.awslab_vpc.id
    availability_zone = var.availability_zone
    cidr_block = "172.16.1.0/24"

    tags = {
        Name = "Public subnet for webserver"
    }
}

resource "aws_subnet" "awslab_sn_private" {
    vpc_id = aws_vpc.awslab_vpc.id
    availability_zone = var.availability_zone
    cidr_block = "172.16.2.0/24"

    tags = {
        Name = "Private subnet for database"
    }
}

resource "aws_security_group" "awslab_sg_public" {
    vpc_id = aws_vpc.awslab_vpc.id

    # icmp
    ingress {
        protocol  = 1
        from_port = -1
        to_port   = -1
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    # ssh ipv4
    ingress {
        protocol  = 6
        from_port = 22
        to_port   = 22
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    # http
    ingress {
        protocol  = 6
        from_port = 80
        to_port   = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "Public security group"
    }
}

resource "aws_security_group" "awslab_sg_private" {
    vpc_id = aws_vpc.awslab_vpc.id

    # icmp
    ingress {
        protocol  = 1
        from_port = -1
        to_port   = -1
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    # ssh
    ingress {
        protocol  = 6
        from_port = 22
        to_port   = 22
        cidr_blocks = [aws_subnet.awslab_sn_public.cidr_block]
    }

    # database
    ingress {
        protocol  = 6
        from_port = 3110
        to_port   = 3110
        cidr_blocks = [aws_subnet.awslab_sn_public.cidr_block]
    }

    tags = {
        Name = "Private security group"
    }
}

resource "aws_instance" "awslab_webserver" {
    ami                 = var.ami
    availability_zone   = var.availability_zone
    instance_type       = "t2.micro"
    key_name            = "dos_key"
    subnet_id           = aws_subnet.awslab_sn_public.id
    associate_public_ip_address = true
    vpc_security_group_ids      = [aws_security_group.awslab_sg_public.id]
    
    root_block_device {
        volume_size = 8
        volume_type   = "gp3"
    }

    user_data = file("./userdata/bootstrap_webserver")

    tags = {
        Name = "webserver"
    }
}

resource "aws_instance" "awslab_database" {
    ami                 = var.ami
    availability_zone   = var.availability_zone
    instance_type       = "t2.micro"
    key_name            = "dos_key"
    subnet_id           = aws_subnet.awslab_sn_private.id
    vpc_security_group_ids      = [aws_security_group.awslab_sg_private.id]

    root_block_device {
        volume_size = 8
        volume_type   = "gp3"
    }

    user_data = file("./userdata/bootstrap_database")

    tags = {
        Name = "database"
    }
}

output "awslab_webserver_public_ip" {
  value = [aws_instance.awslab_webserver.public_ip]
}

output "awslab_webserver_private_ip" {
  value = [aws_instance.awslab_webserver.private_ip]
}

output "awslab_database_private_ip" {
  value = [aws_instance.awslab_database.private_ip]
}
