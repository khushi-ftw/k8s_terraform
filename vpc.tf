resource "aws_vpc" "kubernetes_test_vpc" {
  cidr_block = var.vpc_network_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.eks_cluster_name
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    # to tell EKS service that this is a Kubernetes shared resource, can be used across clusters and should not be removed
  }    
}