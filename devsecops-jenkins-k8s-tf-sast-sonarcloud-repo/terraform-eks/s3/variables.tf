variable "region" {
  default = "us-west-1"
}

variable "bucket_name" {}

variable "dynamodb_table_name" {
  default = "terraform-lock"
}