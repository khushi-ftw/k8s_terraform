resource "aws_vpc" "kubernetes_test_vpc" {
  cidr_block = var.vpc_network_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.eks_cluster_name
  }    
}

resource "aws_subnet" "private_subnets" {
  for_each = var.vpc_pvt_subnet_cidr
  vpc_id = aws_vpc.kubernetes_test_vpc.id
  cidr_block = each.value
  tags = {
    Name = "${var.eks_cluster_name}_pvt_subnet_${each.key}"
  }
}