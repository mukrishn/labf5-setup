curl -o  /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt   https://password.corp.redhat.com/RH-IT-Root-CA.crt

oc -n f5-lb create configmap my-registry-certs --from-file /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt

oc patch CDIConfig config --type='json' -p='[{"op": "replace", "path": "/spec/scratchSpaceStorageClass", "value": "hostpath-provisioner"}]'

oc patch sriovoperatorconfig default --type=merge -n openshift-sriov-network-operator --patch '{ "spec": { "enableOperatorWebhook": false } }'
