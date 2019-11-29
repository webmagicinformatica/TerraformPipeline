provider "aws" {
  region = "eu-west-1"
}

terraform {
  required_version = "~> 0.11.3"

  backend "s3" {
    region         = "eu-west-1"
    bucket         = "api-tf-states"
    key            = "terraform.tfstate"
    encrypt        = true
    dynamodb_table = "terraformLocks"
  }
}

# Elastic Search variables
variable "domain_name" {}

variable "elasticsearch_version" {}
variable "instance_count" {}
variable "instance_type" {}
variable "dedicated_master_type" {}
variable "es_zone_awareness" {}
variable "ebs_volume_size" {}
variable "arn_access" {}
variable "encryption_enabled" {}
variable "environment" {}

# VPC variables
variable "vpc_name" {}

variable "owner" {}
variable "proj_name" {}
variable "vpc_cidr" {}

variable "pub_sub_cidr" {
  type = "list"
}

variable "pri_sub_cidr" {
  type = "list"
}

variable "public_eip_id" {
  type = "list"
}

# SG
variable "es_sg_name" {}

# s3
variable "name" {}
variable "versioning" {}
variable "namespace" {}

# Lambda

variable "radiussearch_lambda_policy" {}
variable "radiussearch_lambda_role" {}
variable "Storelocator_ES_Lifecycle" {}


