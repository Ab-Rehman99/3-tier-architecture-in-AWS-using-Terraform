terraform {
  #############################################################
  ## First run only Local Backend code 
  ## AFTER RUNNING TERRAFORM APPLY (WITH LOCAL BACKEND)
  ## YOU WILL UNCOMMENT The " backend "s3" " THEN RE-RUN TERRAFORM INIT TO SWITCH FROM LOCAL BACKEND TO REMOTE AWS BACKEND
  #############################################################
  backend "s3" {
    bucket         = "my-remote-tf-state-file" # REPLACE WITH YOUR BUCKET NAME
    key            = "terraform/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "my-remote-tf-state-file" # REPLACE WITH YOUR BUCKET NAME
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  bucket        = aws_s3_bucket.terraform_state.bucket 
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locking"
  billing_mode = "PROVISIONED"

  read_capacity  = 1  # Set the minimum read capacity to 1
  write_capacity = 1  # Set the minimum write capacity to 1

  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}