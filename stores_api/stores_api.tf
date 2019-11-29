# Creae VPC
module "vpc" {
  source             = "git::https://BITBUCKET_CREDENTIALS@bitbucket.org/DCGOnline/terraform_modules.git//modules/vpc"
  name               = "${var.vpc_name}"
  cidr               = "${var.vpc_cidr}"
  public_subnets     = "${var.pub_sub_cidr}"
  private_subnets    = "${var.pri_sub_cidr}"
  enable_nat_gateway = false
  environment        = "${var.environment}"
  terraform          = true
  owner              = "${var.owner}"

  tags {
    Project = "${var.proj_name}"
  }
}
module "aws_vpc_endpoint" "vpcep" {
  source        = "git::https://BITBUCKET_CREDENTIALS@bitbucket.org/DCGOnline/terraform_modules.git?ref=feature/gdpr-infra-changes//modules/vpc-endpoint"
  vpc_id            = "${module.vpc.vpc_id}"
  service_name      = "com.amazonaws.eu-west-1.s3"
  route_table_ids     = ["${module.vpc.private_route_tables}", "${module.vpc.public_route_tables}",]
}

# Create es security group under /sg
module "es-security-group" {
  source              = "git::https://BITBUCKET_CREDENTIALS@bitbucket.org/DCGOnline/terraform_modules.git//modules/sg/es-sg"
  security_group_name = "${var.es_sg_name}"
  vpc_id              = "${module.vpc.vpc_id}"
}

# Create ES Cluster
module "es" {
  source                = "git::https://BITBUCKET_CREDENTIALS@bitbucket.org/DCGOnline/terraform_modules.git//modules/elasticsearch"
  domain_name           = "${var.domain_name}"
  elasticsearch_version = "${var.elasticsearch_version}"

  vpc_options = {
    security_group_ids = ["${module.es-security-group.id}"]
    subnet_ids         = ["${module.vpc.public_subnets}"]
  }

  encryption_enabled    = "${var.encryption_enabled}"
  instance_count        = "${var.instance_count}"
  instance_type         = "${var.instance_type}"
  dedicated_master_type = "${var.dedicated_master_type}"
  es_zone_awareness     = "${var.es_zone_awareness}"
  ebs_volume_size       = "${var.ebs_volume_size}"
  ebs_enabled           = true
  environment           = "${var.environment}"
  arn_access            = "${var.arn_access}"
}

output "domain_id" {
  value = "${module.es.domain_id}"
}

output "endpoint" {
  value = "${module.es.endpoint}"
}

output "arn" {
  value = "${module.es.arn}"
}

output "kibana" {
  value = "${module.es.endpoint}"
}

# Create S3 bucket 
module "s3" {
  source    = "git::https://BITBUCKET_CREDENTIALS@bitbucket.org/DCGOnline/terraform_modules.git//modules/s3"
  name      = "${var.name}"
  namespace = "${var.namespace}"
  s3_region = "eu-west-1"
  versioning = "${var.versioning}"

  tags {
    Environment = "${var.environment}"
    Terrafrom   = true
  }
}

# Lambda Exection Policy
resource "aws_iam_policy" "radiussearch_lambda_policy" {
  name        = "${var.radiussearch_lambda_policy}"
  path        = "/"
  description = "radiussearch lambda policy"

  policy = <<EOF
{
"Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "es:ESHttpHead",
                "es:ESHttpPost",
                "es:ESHttpGet",
                "s3:ListBucket",
                "es:ListTags",
                "es:DescribeElasticsearchDomains",
                "es:ESHttpDelete",
                "es:ESHttpPut"
            ],
            "Resource": [
                "arn:aws:s3:::s3-sapmdm-radiussearch-data",
                "arn:aws:es:eu-west-1:132281477581:domain/radiussearch-dev-cluster"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeVolumesModifications",
                "ec2:DescribeSnapshots",
                "ec2:DescribePlacementGroups",
                "ec2:DescribeHostReservationOfferings",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeVolumeStatus",
                "ec2:DescribeScheduledInstanceAvailability",
                "ec2:DescribeSpotDatafeedSubscription",
                "ec2:DescribeVolumes",
                "ec2:DescribeFpgaImageAttribute",
                "ec2:DescribeExportTasks",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeNetworkInterfacePermissions",
                "ec2:DescribeReservedInstances",
                "ec2:DescribeKeyPairs",
                "s3:HeadBucket",
                "ec2:DescribeNetworkAcls",
                "ec2:DescribeRouteTables",
                "ec2:DescribeReservedInstancesListings",
                "ec2:DescribeEgressOnlyInternetGateways",
                "ec2:DescribeSpotFleetRequestHistory",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeVpcClassicLinkDnsSupport",
                "ec2:DescribeVpnConnections",
                "ec2:DescribeSnapshotAttribute",
                "ec2:DescribeVpcPeeringConnections",
                "ec2:DescribeReservedInstancesOfferings",
                "ec2:DescribeIdFormat",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeVpcEndpointServiceConfigurations",
                "ec2:DescribePrefixLists",
                "ec2:DescribeVolumeAttribute",
                "ec2:DescribeInstanceCreditSpecifications",
                "ec2:DescribeVpcClassicLink",
                "ec2:DescribeImportSnapshotTasks",
                "ec2:CreateNetworkInterface",
                "ec2:DescribeVpcEndpointServicePermissions",
                "ec2:DescribeScheduledInstances",
                "ec2:DescribeImageAttribute",
                "ec2:DescribeVpcEndpoints",
                "ec2:DescribeReservedInstancesModifications",
                "ec2:DescribeElasticGpus",
                "ec2:DescribeSubnets",
                "es:ListElasticsearchInstanceTypes",
                "ec2:DescribeVpnGateways",
                "es:DescribeElasticsearchInstanceTypeLimits",
                "ec2:DescribeMovingAddresses",
                "ec2:DescribeAddresses",
                "ec2:DescribeInstanceAttribute",
                "ec2:DescribeRegions",
                "ec2:DescribeFlowLogs",
                "ec2:DescribeDhcpOptions",
                "ec2:DescribeVpcEndpointServices",
                "ec2:DescribeSpotInstanceRequests",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeSpotPriceHistory",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeNetworkInterfaceAttribute",
                "ec2:DescribeVpcEndpointConnections",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeHostReservations",
                "ec2:DescribeIamInstanceProfileAssociations",
                "ec2:DescribeTags",
                "ec2:DescribeLaunchTemplateVersions",
                "ec2:DescribeBundleTasks",
                "ec2:DescribeIdentityIdFormat",
                "ec2:DescribeImportImageTasks",
                "ec2:DescribeClassicLinkInstances",
                "ec2:DescribeNatGateways",
                "ec2:DescribeCustomerGateways",
                "ec2:DescribeVpcEndpointConnectionNotifications",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSpotFleetRequests",
                "ec2:DescribeHosts",
                "ec2:DescribeImages",
                "ec2:DescribeFpgaImages",
                "ec2:DescribeSpotFleetInstances",
                "es:ListDomainNames",
                "s3:ListAllMyBuckets",
                "ec2:DescribeSecurityGroupReferences",
                "ec2:DescribeVpcs",
                "ec2:DescribeConversionTasks",
                "es:ListElasticsearchVersions",
                "ec2:DescribeStaleSecurityGroups"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# Lambda Role For Storelocator_ES_Lifecycle
resource "aws_iam_role" "radiussearch_lambda_role" {
    name = "${var.radiussearch_lambda_role}"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "radiussearch_lambda_policy" {
    role       = "${aws_iam_role.radiussearch_lambda_role.name}"
    policy_arn = "${aws_iam_policy.radiussearch_lambda_policy.arn}"
}

# ES Lifecycle Lambda
resource "aws_lambda_function" "Storelocator_ES_Lifecycle" {
    function_name = "${var.Storelocator_ES_Lifecycle}"
    s3_bucket     = "s3-sapmdm-radiussearch-data"
    s3_key        = "radiussearch-es-lifecycle.zip"
    role          = "${aws_iam_role.radiussearch_lambda_role.arn}"
    handler       = "index.handler"
  	runtime       = "nodejs8.10"
}

resource "aws_cloudwatch_event_rule" "Everyday_at_8AM" {
    name = "Everyday_at_8AM"
    description = "Fires every five minutes"
    schedule_expression = "cron(0 8 * * ? *)"
}

resource "aws_cloudwatch_event_target" "Storelocator_ES_Lifecycle_Everyday_at_8AM" {
    rule = "${aws_cloudwatch_event_rule.Everyday_at_8AM.name}"
    target_id = "Storelocator_ES_Lifecycle"
    arn = "${aws_lambda_function.Storelocator_ES_Lifecycle.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_Storelocator_ES_Lifecycle" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.Storelocator_ES_Lifecycle.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.Everyday_at_8AM.arn}"
}