resource "aws_eks_cluster" "k8s_test_eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.k8s_test_iam_role.arn

  vpc_config {
    subnet_ids = [
        for subnet in aws_subnet.private_subnets : subnet.id
    ]
    security_group_ids = [aws_security_group.k8s_test_security_group.id]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.k8s_test-AmazonEKSClusterPolicy,
  ]
}