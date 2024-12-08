resource "aws_instance" "flaskserver" {
  ami           = "ami-053b12d3152c0cc71"  # Specify your desired AMI (Ubuntu, etc.)
  instance_type = "t2.micro"  # EC2 instance type

  key_name = "testing"  # SSH key pair to access the instance (replace with your key pair name)

  # Attach the IAM Instance Profile for S3 access
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  # Specify the security group (allows SSH and outbound traffic)
  vpc_security_group_ids = [aws_security_group.flaskserver-sg.id]

  # Place the EC2 instance in the public subnet of the VPC
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnets[0]  # Using the first public subnet (you can change this if needed)

  # Enable Public IP (required to access the instance from the internet)
  associate_public_ip_address = true

  # Upload the app.py file using the file provisioner
  provisioner "file" {
    source      = "app.py"  # Local path to app.py (from the same directory as Terraform configuration)
    destination = "/home/ubuntu/app.py"  # Destination path on the EC2 instance

    # Define the connection configuration for SSH
    connection {
      type        = "ssh"
      host        = self.public_ip  # Use the public IP of the instance
      user        = "ubuntu"  # The default user for Ubuntu-based AMIs
      private_key = file("testing.pem")  # Path to the SSH private key
    }
  }

  # Optional: Specify a user-data script to install dependencies and start the Flask app
  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y python3-pip python3-venv
              pip3 install --upgrade pip
              pip3 install Flask boto3  
              nohup python3 /home/ubuntu/app.py > /home/ubuntu/app.log 2>&1 &  
              EOF

  tags = {
    Name = "Flask Server"
  }

  # Optional: Set up monitoring (CloudWatch logs, etc.)
  monitoring = true
}
