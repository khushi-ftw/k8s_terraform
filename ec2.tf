resource "aws_eks_node_group" "k8s_test_node_group" {
    cluster_name    = var.eks_cluster_name
    node_group_name = "k8s_test_node_group"
    node_role_arn   = aws_iam_role.k8s_test_node_group.arn
    subnet_ids      = [
        for subnet in aws_subnet.private_subnets : subnet.id
    ]
    capacity_type = "ON_DEMAND"
    instance_types = ["t3.small"]

    scaling_config {
        desired_size = 1
        max_size     = 4
        min_size     = 1
    }

    update_config {
        max_unavailable = 2
    }

    # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
    # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
    depends_on = [
        aws_iam_role_policy_attachment.k8s_test_node_group-AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.k8s_test_node_group-AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.k8s_test_node_group-AmazonEC2ContainerRegistryReadOnly,
    ]
}

# resource "null_resource" "node_annotate" {
#     depends_on = [
#       kubernetes_manifest.pod_eni_cfg
#     ]
#     triggers = {
#         always_run = timestamp()
#     }
#     provisioner "local-exec" {
#         on_failure  = fail
#         when = create
#         interpreter = ["/bin/bash", "-c"]
#         command     = <<EOT
#             ./annotate_node.sh
#         EOT
#     }
# }

resource "kubernetes_annotations" "node_annotate" {
    for_each = aws_eks_node_group.k8s_test_node_group.Node
    api_version = "v1"
    kind        = "Node"
    metadata {
        name = "my-config"
    }
    annotations = {
        "owner" = "myteam"
    }
}