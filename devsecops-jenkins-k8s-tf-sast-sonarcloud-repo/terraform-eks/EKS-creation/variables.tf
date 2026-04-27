variable "region" {
  default = "us-west-1"
}

variable "cluster_name" {
  default = "jenkins-eks-cluster"
}

variable "cluster_version" {
  default = "1.29"
}

# 🔥 EXISTING INFRA INPUTS
variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}