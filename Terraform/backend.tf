terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "path/to/terraform.tfstate"
    region = "ap-south-1"

    # Optional: Use DynamoDB for state locking to prevent concurrent updates
    dynamodb_table = "your-dynamodb-table"
  }
}
