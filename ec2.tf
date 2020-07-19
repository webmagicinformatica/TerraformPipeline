variable "name" {}
variable "instancetype" {}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}

resource "aws_instance" "ec2example" {
  ami = "ami-00eb20669e0990cb4"
  instance_type = "${var.instancetype}"

  tags = {
      Name = "${var.name}"
  }
}
