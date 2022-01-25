resource "aws_route_table" "public_subnet_route_table" {
    for_each = aws_subnet.public_subnets
    vpc_id = aws_vpc.kubernetes_test_vpc.id
    tags = {
      Name = "${var.eks_cluster_name}_pub_route_table_${each.key}"
    }
}

resource "aws_default_route_table" "default_subnet_route_table" {
    default_route_table_id = aws_vpc.kubernetes_test_vpc.default_route_table_id
    tags = {
      Name = "${var.eks_cluster_name}_default_route_table"
    }
}

resource "aws_route_table" "private_subnet_route_table" {
    for_each = aws_subnet.private_subnets
    vpc_id = aws_vpc.kubernetes_test_vpc.id
    tags = {
      Name = "${var.eks_cluster_name}_pvt_route_table_${each.key}"
    }
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
    for_each = aws_subnet.public_subnets
    subnet_id = aws_subnet.public_subnets[each.key].id
    route_table_id = aws_route_table.public_subnet_route_table[each.key].id
}

resource "aws_route_table_association" "private_subnet_route_table_association" {
    for_each = aws_subnet.private_subnets
    subnet_id = aws_subnet.private_subnets[each.key].id
    route_table_id = aws_route_table.private_subnet_route_table[each.key].id
}

resource "aws_route" "public_subnet_ig_route" {
    for_each = aws_subnet.public_subnets
    route_table_id = aws_route_table.public_subnet_route_table[each.key].id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8_test_ig.id
}

resource "aws_route" "private_subnet_nat_gateway_route" {
    for_each = aws_subnet.private_subnets
    route_table_id = aws_route_table.private_subnet_route_table[each.key].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_nat_gateway[each.key].id
}