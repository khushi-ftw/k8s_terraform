resource "aws_lb" "k8s_test_lb" {
    subnets = [
        for subnet in aws_subnet.private_subnets : subnet.id
    ] 
    internal = false
    load_balancer_type = "network"
    tags = {
        Name = var.eks_lb_name
    }
}

resource "aws_lb_target_group" "k8s_test_target_group" {
    protocol = "TCP"
    port = 6443
    vpc_id = aws_vpc.kubernetes_test_vpc.id
    target_type = "ip"
    tags = {
        Name = "${var.eks_lb_name}_target_group"
    }
}

resource "aws_lb_target_group_attachment" "k8s_test_target_id" {
    for_each = toset(["10.0.1.10", "10.0.1.11", "10.0.1.12"])
    target_group_arn = aws_lb_target_group.k8s_test_target_group.arn
    target_id = each.value
}

resource "aws_lb_listener" "k8s_test_listener" {
    load_balancer_arn = aws_lb.k8s_test_lb.arn
    protocol = "TCP"
    port = 443
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.k8s_test_target_group.arn
    }
}
