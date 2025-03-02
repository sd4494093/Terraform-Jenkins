provider "aws" {
    region = "ap-east-1"
}


resource "aws_instance" "foo" {
  ami                         = "ami-0123e5d7542358c86"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.dev-subnet-1.id
  vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "Jenkinspipline"
  }
}