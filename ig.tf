resource "aws_internet_gateway" "k8_test_ig" {
  vpc_id = aws_vpc.kubernetes_test_vpc.id
  tags = {
    Name = "${var.eks_cluster_name}_ig"
  } 
}