# comm=`printf "kubectl get node --selector='eks.amazonaws.com/nodegroup==k8s_test_node_group' -o json" kubernetes_test`
# allnodes=`eval $comm`
# len=`echo $allnodes | jq '.items | length-1'`
# # iterate through the nodes and apply the annotation - so the eniConfig can match
# for i in `seq 0 $len`; do
# nn=`echo $allnodes | jq ".items[(${i})].metadata.name" | tr -d '"'`
# nz=`echo $allnodes | jq ".items[(${i})].metadata.labels" | grep failure | grep zone | cut -f2 -d':' | tr -d ' ' | tr -d ','| tr -d '"'`
# echo $nn $nz $nr
# echo "kubectl annotate node ${nn} k8s.amazonaws.com/eniConfig=${nz}-pod-netconfig"
# kubectl annotate node ${nn} k8s.amazonaws.com/eniConfig=${nz}-pod-netconfig
# done