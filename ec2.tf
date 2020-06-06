variable "name" {}

variable "env" {}

provider "aws" {
  region     = "us-west-2"
  access_key = "${var.Access_key_ID}"
  secret_key = "${var.Secret_access_key}"
}

resource "aws_instance" "ec2example" {
  ami = "ami-00eb20669e0990cb4"
  instance_type = "t2.micro"

  tags = {
      Name = "${var.name}"
  }
}
