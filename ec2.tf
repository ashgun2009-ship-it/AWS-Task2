# 1. Шукаємо існуючу VPC за тегом
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["cmtr-o3e0v1ec-vpc"]
  }
}

# 2. Шукаємо публічну підмережу всередині цієї VPC
data "aws_subnet" "selected" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = ["cmtr-o3e0v1ec-subnet-public-a"] # стандартне ім'я публічної підмережі на платформі
  }
}

# 3. Шукаємо готову групу безпеки за її точним іменем з ТЗ
data "aws_security_group" "selected" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "group-name"
    values = ["cmtr-o3e0v1ec-sg"]
  }
}

# 4. Створюємо екземпляр EC2
resource "aws_instance" "web" {
  ami                         = "ami-0905a3c97561e0b69" # Ubuntu 22.04 LTS в eu-west-1
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnet.selected.id
  vpc_security_group_ids      = [data.aws_security_group.selected.id]
  key_name                    = aws_key_pair.auth.key_name
  associate_public_ip_address = true

  tags = {
    Name    = "cmtr-o3e0v1ec-ec2"
    Project = "epam-tf-lab"
    ID      = "cmtr-o3e0v1ec"
  }
}