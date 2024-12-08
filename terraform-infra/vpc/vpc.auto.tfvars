# VPC Variables
vpc_name = "project-terraform-vpc"
vpc_cidr_block = "10.1.0.0/16"
#vpc_availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
vpc_public_subnets = ["10.1.0.0/20", "10.1.16.0/20", "10.1.32.0/20"]
vpc_private_subnets = ["10.1.48.0/20", "10.1.64.0/20", "10.1.80.0/20"]
