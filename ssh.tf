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