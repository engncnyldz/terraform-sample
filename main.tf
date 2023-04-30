terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
    region = "eu-central-1"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    filter {
        name = "root-device-type"
        values = ["ebs"]
    }
    filter {
        name = "architecture"
        values = ["x86_64"]
    }
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "my_ip" {}

resource "aws_vpc" "my-vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        Name = "my-vpc"
    }
}

resource "aws_subnet" "my-subnet" {
    tags = {
        Name = "my-subnet"
    }
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = var.subnet_cidr_block
}

resource "aws_security_group" "my-security-group" {
    tags = {
        Name = "my-security-group"
    }
    vpc_id = aws_vpc.my-vpc.id
    name = "Allow all access from my IP"

    ingress {
        description = "Access from my IP"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.my_ip]
        
    }

}

resource "aws_instance" "my-ec2" {
    tags = {
        Name = "my-ec2"
    }

    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.my-subnet.id
    vpc_security_group_ids = [aws_security_group.my-security-group.id]
    associate_public_ip_address = true
}

output "my-ec2-public-ip" {
    value = aws_instance.my-ec2.public_ip
}
