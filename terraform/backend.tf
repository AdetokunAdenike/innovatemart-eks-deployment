terraform {
  backend "s3" {
    bucket        = "innovatemart-terraform-state-eu-west-1-nikki"
    key           = "eks/terraform.tfstate"
    region        = "eu-west-1"
    dynamodb_table = "terraform-locks"
  }
}
