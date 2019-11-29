# Elastic Search variables
domain_name = "dev-demo"

elasticsearch_version = "6.2"

instance_count = 1

instance_type = "t2.small.elasticsearch"

dedicated_master_type = "t2.small.elasticsearch"

es_zone_awareness = "false"

ebs_volume_size = 10

arn_access = "xx"

encryption_enabled = "false"
environment = "dev"

# VPC variables
vpc_name = "es-vpc-name"

proj_name = "gdpr"

owner = "api_team"

vpc_cidr = "10.1.0.0/16"

pub_sub_cidr = ["10.1.1.0/24"]

pri_sub_cidr = ["10.1.2.0/24"]

public_eip_id = ["eipalloc-019e983d8b721ce75"]

# SG
es_sg_name = "es-sg-name-demo"

# s3
versioning = true

name = "stores-api-demo"

namespace = "dev-demo"

#Lambda

radiussearch_lambda_policy = "radiussearch_lambda_policy_demo"
radiussearch_lambda_role = "radiussearch_lambda_role_demo"
Storelocator_ES_Lifecycle = "Storelocator_ES_Lifecycle_demo"