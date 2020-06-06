provider "aws" {
  region     = "us-west-2"
  access_key = "AKIAY7UO4T4X7RQ44WDO"
  secret_key = "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"
}

resource "aws_instance" "ec2example" {
  ami = "ami-00eb20669e0990cb4"
  instance_type = "t2.micro"

}
