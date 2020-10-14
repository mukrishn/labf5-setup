curl -o  /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt   https://password.corp.redhat.com/RH-IT-Root-CA.crt

oc -n f5-lb create configmap my-registry-certs --from-file /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt

oc patch CDIConfig config --type='json' -p='[{"op": "replace", "path": "/spec/scratchSpaceStorageClass", "value": "hostpath-provisioner"}]'

oc patch sriovoperatorconfig default --type=merge -n openshift-sriov-network-operator --patch '{ "spec": { "enableOperatorWebhook": false } }'

oc patch networks.operator.openshift.io/cluster --type='merge' -p "$(cat <<- EOF
spec:
  additionalNetworks:
  - name: bigip-mgmt
    namespace: f5-lb
    rawCNIConfig: '{ "cniVersion": "0.3.1", "type": "bridge", "bridge": "bigip-mgmt",
      "ipMasq": false, "isGateway": false, "isDefaultGateway": false, "forceAddress":
      false, "hairpinMode": false,"promiscMode":false }'
    type: Raw
  - name: bigip-ha
    namespace: f5-lb
    rawCNIConfig: '{ "cniVersion": "0.3.1", "type": "bridge", "bridge": "bigip-ha",
      "ipMasq": false, "isGateway": false, "isDefaultGateway": false, "forceAddress":
      false, "hairpinMode": false,"promiscMode":false }'
    type: Raw
EOF
)"

oc patch dns.operator/default --type='merge' -p "$(cat <<- EOF
  spec:
    servers:
    - forwardPlugin:
        upstreams:
        - 192.168.222.161
      name: f5nat64dns
      zones:
      - nat64.murali722.myocp4.com
EOF
)"


oc create secret generic bigip-login -n kube-system --from-literal=username=admin --from-literal=password=changepwd
oc create serviceaccount k8s-bigip-ctlr -n kube-system
oc create clusterrolebinding k8s-bigip-ctlr-clusteradmin --clusterrole=cluster-admin --serviceaccount=kube-system:k8s-bigip-ctlr

