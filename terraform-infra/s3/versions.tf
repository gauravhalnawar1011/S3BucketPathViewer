# Terraform Settings Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.67"      
     }
  }
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "terraform-state-bucket-project-new-973148501077123-tf"
    key    = "terraform-tf-state-remote/s3-bucket/terraform.tfstate"
    region = "ap-south-1" 
 
    # For State Locking
    dynamodb_table = "terraform-state-locks"    
  }  
}

