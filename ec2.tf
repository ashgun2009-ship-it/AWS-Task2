terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

# Динамічно шукаємо VPC за тегом
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-o3e0v1ec-vpc"]
  }
}

# Динамічно шукаємо підмережу всередині знайденої VPC
data "aws_subnet" "selected" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = ["cmtr-o3e0v1ec-public_subnet"]
  }
}

# Динамічно шукаємо групу безпеки за назвою всередині VPC
data "aws_security_group" "selected" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "group-name"
    values = ["cmtr-o3e0v1ec-sg"]
  }
}

resource "aws_instance" "web" {
  ami                         = "ami-0905a3c97561e0b69"
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.selected.id
  vpc_security_group_ids      = [data.aws_security_group.selected.id]
  key_name                    = aws_key_pair.cmtr-o3e0v1ec-keypair.key_name
  associate_public_ip_address = true

  tags = {
    Name    = "cmtr-o3e0v1ec-ec2"
    Project = "epam-tf-lab"
    ID      = "cmtr-o3e0v1ec"
  }
}