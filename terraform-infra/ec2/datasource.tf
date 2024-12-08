data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "terraform-state-bucket-project-new-973148501077123-tf"
    key    = "terraform-tf-state-remote/vpc/terraform.tfstate"
    region = "ap-south-1" 
  }
}

