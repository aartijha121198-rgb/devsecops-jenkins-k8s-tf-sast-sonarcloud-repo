terraform {
  backend "s3" {
    bucket         = "jenkins-bucket-1-aaru-12345"
    key            = "eks/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-lock-1"
  }
}