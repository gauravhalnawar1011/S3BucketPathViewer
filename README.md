
# S3 Bucket Path Viewer with Terraform Deployment

This project implements a solution to expose the contents of an S3 bucket through an HTTP service. It also includes Terraform scripts to provision the required AWS infrastructure, including S3, DynamoDB, VPC, EC2, and IAM roles.

## Features

1. **Python HTTP Service**: 
   - Lists the contents of an S3 bucket.
   - Handles subdirectory navigation and non-existent paths.
2. **Terraform Scripts**:
   - Configures an S3 bucket and DynamoDB for remote state storage.
   - Provisions a VPC, EC2 instance, and associated networking.
   - IAM roles for secure access to AWS resources.
3. **Infrastructure Setup**:
   - S3 for state files and content.
   - DynamoDB for state file locking.
   - EC2 instance hosting the Python application.

---

## Prerequisites

1. **AWS Free Tier Account**
   - Create an AWS account.
   - Set up an IAM user with the necessary permissions.
2. **Tools Required**
   - AWS CLI
   - Terraform
   - Python 3.x
   - Flask and Boto3 (for the Python application)

---

## AWS Credential Setup

AWS credentials can be configured in three ways:

1. **Using `~/.aws/credentials`**:
   ```plaintext
   [terraform-project]
   aws_access_key_id = YOUR_ACCESS_KEY
   aws_secret_access_key = YOUR_SECRET_KEY
   ```
   Update `provider.tf` to reference this profile.

2. **Using AWS CLI**:
   Run the following command and input your credentials:
   ```bash
   aws configure
   ```

3. **Using Terraform Variables**:
   - Define credentials in `variables.tf`.
   - Reference them in `provider.tf`:
     ```hcl
     variable "aws_access_key" {}
     variable "aws_secret_key" {}

     provider "aws" {
       access_key = var.aws_access_key
       secret_key = var.aws_secret_key
       region     = "us-west-2"
     }
     ```

---

## Steps to Deploy

### 1. **Remote State Storage**

- Create an S3 bucket for storing Terraform state files:
  - Name: `terraform-state-bucket-project-new-973148501077123-tf`
  - ![image](https://github.com/user-attachments/assets/6b7c99d4-e8b2-421c-bc32-65d7b15431dd)

- Create a DynamoDB table for state locking.
- ![image](https://github.com/user-attachments/assets/37407b45-aee4-4277-a8b2-de24f6403a64)


### 2. **Setup S3 and Folders**

Navigate to `terraform-infra/s3-andDynamoDB-backend` and:
1. Update your AWS credentials in the Terraform variables or profile.
2. Replace the bucket name with a globally unique name in `backend.tf`.
3. Run Terraform:
   ```bash
   cd terraform-infra/s3-andDynamoDB-backend
   terraform init
   terraform validate
   terraform plan
   terraform apply or terraform apply --auto-approve
   ```
4. This will:
   - Create an S3 bucket.
   - Add folders `dir1` and `dir2` to the bucket.
   - ![image](https://github.com/user-attachments/assets/b3a00bd1-62a5-4f66-8460-0235f2796fad)
   - ![image](https://github.com/user-attachments/assets/6aaac562-f532-4b2c-973c-8744ac62cfef)


   - Configure bucket policies.


### 3. **Python HTTP Service**

- Navigate to the `src` folder containing the Python script.
- Ensure all dependencies are installed:
  ```bash
  pip install flask boto3
  ```
- Run the Flask server:
  ```bash
  python app.py
  ```
  ![image](https://github.com/user-attachments/assets/06a70964-5133-4e07-9560-4333eb97720b)

- Test the endpoints:
  - List bucket contents: `http://<PUBLIC_IP>:9000/list-bucket-content`
  ![image](https://github.com/user-attachments/assets/afaa84b4-79da-429f-ab85-98ead723c8f0)

  - Navigate `dir1`: `http://<PUBLIC_IP>:9000/list-bucket-content/dir1`
  - ![image](https://github.com/user-attachments/assets/82834d75-a54c-4ff2-8164-76fc4e26dbcc)

  - 
  - Navigate `dir2`: `http://<PUBLIC_IP>:9000/list-bucket-content/dir2`
  - ![image](https://github.com/user-attachments/assets/fcc83607-12ea-4d1a-8feb-949c0dca0c9c)


### 4. **VPC and EC2 Deployment**

- Navigate to the `terraform-infra/vpc` folder:
  - Configure the VPC using `terraform apply`.
- Move to the `terraform-infra/ec2` folder:
  - Deploy an EC2 instance.
  - The EC2 instance will:
  - ![image](https://github.com/user-attachments/assets/14124df5-e749-4f6c-93f8-65923de5f842)

    - Use an IAM role to access S3.
    - Automatically install Flask and dependencies via a startup script.

### 5. **Application Deployment on EC2**

- Access the EC2 public IP.
- Verify the endpoints:
  - Root directory: `http://<EC2_PUBLIC_IP>:9000/list-bucket-content`
  - Subdirectories:
    - `http://<EC2_PUBLIC_IP>:9000/list-bucket-content/dir1`
    - ![image](https://github.com/user-attachments/assets/f508e369-a927-4cd0-9db5-2efb0b82a28b)

    - `http://<EC2_PUBLIC_IP>:9000/list-bucket-content/dir2`
    - ![image](https://github.com/user-attachments/assets/af7225b8-5928-48c9-a72f-7cc8fd06a79a)


---

## Folder Structure

- **`terraform-infra/s3-andDynamoDB-backend`**:
  - Creates S3 bucket and DynamoDB for state files.
- **`terraform-infra/vpc`**:
  - Sets up a VPC for networking.
- **`terraform-infra/ec2`**:
  - Provisions an EC2 instance with the required IAM role and security group.
- **`src`**:
  - Python application source code.

---

## Assumptions

- The S3 bucket name must be globally unique.
- IAM policies are created to allow EC2 to access S3.
- The Python application assumes Flask and Boto3 are installed on the EC2 instance.

---

## Testing

After deploying the EC2 instance and running the application, verify the output by making HTTP requests to the EC2 public IP.

Example:

```bash
curl http://<EC2_PUBLIC_IP>:9000/list-bucket-content
curl http://<EC2_PUBLIC_IP>:9000/list-bucket-content/dir1
curl http://<EC2_PUBLIC_IP>:9000/list-bucket-content/dir2
```

---

## Clean Up

To avoid incurring unnecessary AWS charges:
1. Destroy all Terraform resources:
   ```bash
   terraform destroy
   ```
2. Terminate EC2 instances and delete S3 buckets.

---
