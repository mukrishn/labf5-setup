# labf5-setup
Note: set BIGIP password in all places, grep and replace `changepwd`
### Provisioner
1. Configure Provision node for BIGIP mgmt VLAN - run `nmcli` commands to create interface with IPs. - `sudo bash 00-provnode-setup.sh` 
### Operators
2. Install SRIOV operator - `oc apply -f 10-sriov-op.yaml`
3. Install CNV Operator - `oc apply -f 11-cnv-op.yaml`
### BIGIP
4. Create 2 new namespaces - `oc apply -f 20-namespace.yaml`
5. Once the worker are ready, set up Host path provisioner for VMs - `oc apply -f 30-hpp-setup.yaml`
6. Patch few cluster configs and upload required secrets - `bash 31-oc-patches-1.sh`
7. Wait untill worker are ready
8. Configure Sriov Network Node policy - `oc apply -f 40-sriov-nnp.yml`
9. Configure Sriov Network - `oc apply -f 41-sriov-net.yml`
10. Wait untill workers are ready
11. Create Bridges and interface in workers - `oc apply -f 50-f5bridges.yaml`
12. Add additional networks and few service account for BIGIP - `bash 51-oc-patches-2.sh`
13. Create Data volumes for BIGIP VMs - `oc apply -f 60-datavolume.yaml`
14. Wait untill the datavolume and persistent volume is ready
15. Create BIGIP VMs - `oc apply -f 70-vms.yml`
### BIGIP VM
16. Wait untill VM mgmt IP is reachable from provisioner node and access F5 GUI from browser
17. Run ansible play book to activate license and finish up ingress configuration - `ansible-playbook -i ansible-host -e @ansible-input.yml ansible-playbook` 
### CIS Controller
18. Deploy BIGIP CIS controller pods - `oc apply -f 80-cis-deploy.yaml`
### Test setup
19. Deploy test namespace, pods, service and as3 configmap - `oc apply -f 90-hello-world.yaml` 
20. Access BIGIP GUI and check virtual servers created under AS3 partition and curl against virtual IP from provisioner
