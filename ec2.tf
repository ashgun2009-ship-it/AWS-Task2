resource "aws_instance" "web" {
  ami           = "ami-0905a3c97561e0b69" # Чиста Ubuntu 22.04 LTS в eu-west-1
  instance_type = "t2.micro"

  # Публічна підмережа, яку ми знайшли на твоєму скриншоті
  subnet_id = "subnet-07464cc4c732baa90"

  # СЮДИ ВСТАВ РЕАЛЬНИЙ ID СВОЄЇ ГРУПИ БЕЗПЕКИ З КОНСОЛІ AWS:
  vpc_security_group_ids = ["sg-0176a1ac997e1ee59"]

  # Кажемо серверу використовувати ключ по його імені (Terraform не буде його створювати)
  key_name                    = aws_key_pair.cmtr-o3e0v1ec-keypair.key_name
  associate_public_ip_address = true

  tags = {
    Name    = "cmtr-o3e0v1ec-ec2"
    Project = "epam-tf-lab"
    ID      = "cmtr-o3e0v1ec"
  }
}