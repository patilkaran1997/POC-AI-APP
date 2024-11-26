terraform {
  backend "s3" {
    bucket = "my-bucket-ssemo"
    key    = "path/to/terraform.tfstate"
    region = "ap-south-1"

    # Optional: Use DynamoDB for state locking to prevent concurrent updates
    dynamodb_table = "terraform-locks"
  }
}
