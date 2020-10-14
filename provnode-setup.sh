nmcli con add type vlan con-name ens2f1.100 dev ens2f1 id 100 connection.autoconnect yes

nmcli connection modify ens2f1.100 ipv4.address '192.168.223.1/24'
nmcli connection modify ens2f1.100 ipv4.dns '192.168.222.1'
nmcli connection modify ens2f1.100 ipv4.method 'manual'

nmcli connection up ens2f1.100
