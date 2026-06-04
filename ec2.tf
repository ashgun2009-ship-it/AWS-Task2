# 1. Динамічно шукаємо VPC за тегом Name
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-o3e0v1ec-vpc"]
  }
}

# 2. Динамічно шукаємо публічну підмережу в зоні eu-west-1a
data "aws_subnet" "selected" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["cmtr-o3e0v1ec-public_subnet"]
  }

  filter {
    name   = "availability-zone"
    values = ["eu-west-1a"]
  }
}

# 3. Динамічно шукаємо групу безпеки
data "aws_security_group" "selected" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "group-name"
    values = ["cmtr-o3e0v1ec-sg"]
  }
}

# 4. Динамічно шукаємо образ Ubuntu 22.04 LTS
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# 5. Створюємо віртуалку EC2
resource "aws_instance" "cmtr-o3e0v1ec-ec2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.selected.id
  vpc_security_group_ids      = [data.aws_security_group.selected.id]
  key_name                    = aws_key_pair.cmtr-o3e0v1ec-keypair.key_name
  associate_public_ip_address = true

  # Чекаємо, поки ключ повністю зареєструється в AWS
  depends_on = [
    aws_key_pair.cmtr-o3e0v1ec-keypair
  ]

  tags = {
    Name    = "cmtr-o3e0v1ec-ec2"
    Project = "epam-tf-lab"
    ID      = "cmtr-o3e0v1ec"
  }
}