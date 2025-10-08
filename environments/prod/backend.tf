terraform {
  backend "s3" {
    bucket = "terraform-state-autoscaling-alerts"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
    
    # state locking and encryption code
    # encrypt        = true
    # dynamodb_table = "terraform-locks"
  }
}