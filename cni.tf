resource "kubernetes_manifest" "pod_eni_cfg" {
   for_each = aws_subnet.pod_subnets
    provider = kubernetes
    manifest = {
        apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
        kind = "ENIConfig"
        metadata = {
           name = aws_subnet.pod_subnets[each.key].availability_zone
        }
        spec = {
           subnet = each.key
        }
        securityGroups = [
            aws_security_group.k8s_test_security_group.id
        ]
    }
}

resource "kubectl_manifest" "cni_daemonset" {
    yaml_body = templatefile(
        "${path.module}/manifests/daemonset.yaml.tpl",
        {
            CUSTOM_NETWORK_CFG = var.cni_custom_network_cfg,
            DOCKER_IMG = var.cni_docker_img,
            ENI_CONFIG_LABEL = var.cni_eni_config_label,
            INIT_DOCKER_IMG = var.cni_init_docker_img,
        }
    )
    depends_on = [
      kubernetes_manifest.pod_eni_cfg
    ]
}