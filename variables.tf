variable "region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}

variable "eks_cluster_name" {
  description = "eks cluster name"
  type = string
  default = "kubernetes_test"
}

variable "vpc_network_cidr" {
  description = "vpc netwprk cidr range"
  default = "10.0.0.0/16" 
}

