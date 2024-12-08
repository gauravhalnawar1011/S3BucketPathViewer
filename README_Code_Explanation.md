---

# Code Explanation: File Structure and Purpose

This document provides a breakdown of the code, describing the purpose of each file and folder for clarity.

---

## Repository Overview

**Repository Name**: `S3BucketPathViewer`
![image](https://github.com/user-attachments/assets/f0ede573-9d69-4a20-a6e4-76a9ca89de06)


This repository implements the solution for the problem statement, which involves listing S3 bucket contents via an HTTP service and provisioning the infrastructure using Terraform.

---

## Folder Structure and Purpose

### 1. **Root Directory**
Contains the main Python application and infrastructure management folders.
![image](https://github.com/user-attachments/assets/35a40146-5120-42bd-a386-0ec3af6fbf0c)


- **`README.md`**:
  - High-level documentation about the project, setup steps, and usage instructions.
- **`README_Code_Explanation.md`**:
  - Explains the purpose of each file and folder.
- **`src/`**:
  - Contains the Python application code.
- **`terraform-infra/`**:
  - Infrastructure-as-code written in Terraform for modular resource creation.
  - ![image](https://github.com/user-attachments/assets/7fb67528-45b9-4fa6-adcc-a00428c9a370)


---



- **`app.py`**:
  - Main Python application using Flask to create an HTTP service.
  - Lists S3 bucket contents for a given path or the root level.
  - Uses Boto3 to interact with AWS S3.
- **`requirements.txt`**:
  - Lists Python dependencies (`flask`, `boto3`).
  - Install with `pip install -r requirements.txt`.
![image](https://github.com/user-attachments/assets/3c6f5065-b1a6-4ea8-8431-aaf29ee0b4ce)


---

### 3. **`terraform-infra/`**: Infrastructure Code

This folder is modularized into subfolders for better organization.

---

#### a. **`terraform-infra/s3-andDynamoDB-backend/`**
Purpose: Sets up the backend S3 bucket and DynamoDB for storing Terraform state and locks.
![image](https://github.com/user-attachments/assets/0a539434-8f51-40fb-a46d-09d480f7e6e8)



- **`dynmodb.tf`**:
  - Provisions a DynamoDB table for state locking.
  - ![image](https://github.com/user-attachments/assets/62bb0c9c-5215-48ae-83a2-f305e0200df8)

- **`s3.tf`**:
  - Creates an S3 bucket for storing Terraform state files.
![image](https://github.com/user-attachments/assets/8e307016-a390-47e6-acb3-0ff5415aad5c)

- **`provider.tf`**:
  - Specifies AWS credentials and region.
  - ![image](https://github.com/user-attachments/assets/5a5d523a-352e-44be-9bcf-32405dde2cc7)

- **`generic-variables.tf`**:
  - Contains variables for reusable configurations like AWS region.
  - ![image](https://github.com/user-attachments/assets/e745a1d8-4025-47ac-8e7d-11d7c2228fc8)

- **`variables.tf`**:
  - Contains sensitive information (access keys and secret keys).
  - ![image](https://github.com/user-attachments/assets/9095f0eb-1dfc-41a6-8f1f-b9e70acf0251)

- **`output.tf`**:
  - Outputs resource names like S3 bucket name and DynamoDB table name.
  - ![image](https://github.com/user-attachments/assets/3ae0608e-9082-4dfc-8948-94cc46fc9388)


---

#### b. **`terraform-infra/s3/`**
Purpose: Sets up an S3 bucket for storing objects (folders `dir1` and `dir2`).

- **`s3.tf`**:
  - Creates an S3 bucket and uploads objects (folders).
  - ![image](https://github.com/user-attachments/assets/3638e566-2e80-4ece-ad06-34f7a7f39f59)

- **`output.tf`**:
  - Outputs the bucket name and paths.
  - ![image](https://github.com/user-attachments/assets/52503123-1240-44ef-b0b0-1b075a09e80c)

- **`variables.tf`**:
  - Defines configurable parameters like bucket name and region.
  - ![image](https://github.com/user-attachments/assets/cf2f40e4-c5db-40d8-9005-f73578cfc9be)


---

#### c. **`terraform-infra/vpc/`**
Purpose: Configures the Virtual Private Cloud (VPC) for the project.

- **`main.tf`**:
  - Creates a VPC, subnets, route tables, and internet gateway.
- **`output.tf`**:
  - Outputs details like VPC ID and subnet IDs.
- **`variables.tf`**:
  - Contains VPC-related variables like CIDR blocks and region.

---

#### d. **`terraform-infra/ec2/`**
Purpose: Configures EC2 instances for hosting the Python application.

- **`ec2.tf`**:
  - Provisions an EC2 instance with the required tags and AMI.
![image](https://github.com/user-attachments/assets/4731ea38-6540-416d-8468-e0f2039cebf1)

- **`iam.tf`**:
  - Creates IAM roles and policies for EC2 to access S3 content.
  - ![image](https://github.com/user-attachments/assets/4b684c4c-96d8-4299-a708-c1b8c9e67016)

- **`sg.tf`**:
  - Configures security groups to allow required ports (least privilege).
  - ![image](https://github.com/user-attachments/assets/e9adc5d0-bce2-4750-bc4d-8649fa042941)

- **`version.tf`**:
  - Sets up the remote backend for state management using S3.
  - ![image](https://github.com/user-attachments/assets/bb5c6eba-62ea-4b2c-9999-0a6e6e7cce4c)

- **`ec2.tf`**:
  - Bootstraps EC2 with necessary dependencies:
    - Installs Python, Flask, and Boto3.
    - Starts the Python application.
- **`output.tf`**:
  - Outputs the instance public IP and other details.
![image](https://github.com/user-attachments/assets/5c48fd37-2d8a-4005-b0bb-15a722a6c00b)

- **`variables.tf`**:
  - Configurable parameters for instance type, key pair, and region.
  - ![image](https://github.com/user-attachments/assets/f9d01544-df07-4b72-86f9-83f4f1241ac5)


---

## Workflow and Key Steps

1. **S3 and DynamoDB Backend Setup**:
   - Use `terraform-infra/s3-andDynamoDB-backend` to create the backend for Terraform state and locking.

2. **Object Storage in S3**:
   - Use `terraform-infra/s3` to provision an S3 bucket and upload `dir1` and `dir2` folders.

3. **Networking Setup**:
   - Use `terraform-infra/vpc` to create an isolated VPC, subnets, and route tables.

4. **Application Deployment**:
   - Use `terraform-infra/ec2` to deploy an EC2 instance with IAM roles and run the Python application.
   - Verify the application by accessing the endpoint:
     - `http://<instance-public-ip>:9000/list-bucket-content`

---
