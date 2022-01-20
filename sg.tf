resource "aws_security_group" "k8s_test_security_group" {
    vpc_id = aws_vpc.kubernetes_test_vpc.id
    tags = {
        Name = var.eks_security_group_name
    }

    ingress {
        protocol = "all"
        from_port = 0
        to_port = 0
        cidr_blocks = [aws_vpc.kubernetes_test_vpc.cidr_block]
    }

    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        protocol = "tcp"
        from_port = 6443
        to_port = 6443
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        protocol = "tcp"
        from_port = 443
        to_port = 443
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        protocol = "icmp"
        from_port = -1
        to_port = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
}