# terraform {
#   backend "s3" {
#     bucket         = "three-tier-project-bucket" 
#     key            = "three-tier-project/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-lock"
#   }
# }

