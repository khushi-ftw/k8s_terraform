resource "aws_subnet" "private_subnets" {
  for_each = var.vpc_pvt_subnet_cidr
  vpc_id = aws_vpc.kubernetes_test_vpc.id
  availability_zone = "${var.region}${each.key}"
  cidr_block = each.value
  tags = {
    Name = "${var.eks_cluster_name}_pvt_subnet_${each.key}"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "public_subnets" {
  for_each = var.vpc_pub_subnet_cidr
  vpc_id = aws_vpc.kubernetes_test_vpc.id
  availability_zone = "${var.region}${each.key}"
  cidr_block = each.value
  tags = {
    Name = "${var.eks_cluster_name}_pub_subnet_${each.key}"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    "kubernetes.io/role/elb" = "1"
  }
}
