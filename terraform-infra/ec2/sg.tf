resource "aws_security_group" "flaskserver-sg" {
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  name        = "flaskserver Server SG Terraform"
  description = "security group for flaskserver server"

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }



  tags = {
    Name = "EC2 Security Group"
  }
}

