# terraform {
#   backend "s3" {
#     bucket         = "abdul-s3-terraform-backend"
#     encrypt        = true
#     key            = "terraform.tfstate"
#     region         = "ap-south-1"
#     dynamodb_table = "abdul-dynamodb-terraform-backend"
#   }
# }