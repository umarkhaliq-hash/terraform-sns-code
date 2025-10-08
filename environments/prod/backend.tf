terraform {
  backend "s3" {
    bucket = "terraform-state-autoscaling-alerts"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}