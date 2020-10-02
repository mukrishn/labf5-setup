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
