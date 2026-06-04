terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
} # Тут обов'язково має бути перенос рядка (Enter)

provider "aws" {
  region = "eu-west-1"
}

resource "aws_key_pair" "cmtr-o3e0v1ec-keypair" {
  key_name   = "cmtr-o3e0v1ec-keypair"
  public_key = var.ssh_key

  tags = {
    Project = "epam-tf-lab"
    ID      = "cmtr-o3e0v1ec"
  }
}