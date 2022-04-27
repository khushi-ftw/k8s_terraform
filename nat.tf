resource "aws_eip" "elastic_ip_nat" {
     for_each = aws_subnet.public_subnets
  vpc = true
    # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.k8_test_ig]
}

resource "aws_nat_gateway" "public_nat_gateway" {
    for_each = aws_subnet.public_subnets
  allocation_id = aws_eip.elastic_ip_nat[each.key].id
  subnet_id     = aws_subnet.public_subnets[each.key].id

  tags = {
    Name = "${var.eks_cluster_name}_nat_gateway_${each.key}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.k8_test_ig]
}