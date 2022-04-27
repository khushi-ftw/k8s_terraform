# resource "kubernetes_manifest" "pod_eni_cfg" {
#    for_each = aws_subnet.pod_subnets
#     provider = kubernetes
#    manifest = {
#         apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
#        kind = "ENIConfig"
#        metadata = {
#            name = aws_subnet.pod_subnets[each.key].availability_zone
#        }
#        spec = {
#            subnet = each.key
#             securityGroups = [
#                 aws_security_group.k8s_test_security_group
#             ]
#         }
#     }
# }