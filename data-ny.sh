#!/usr/bin/env bash
apt-get install vlan
modprobe 8021q
echo "8021q" >> /etc/modules
cat <<EOF>> /etc/network/interfaces
auto bond0.29
iface bond0.29 inet static
    pre-up sleep 5
    address 192.168.29.25
    netmask 255.255.255.0
    vlan-raw-device bond0
EOF
ip link set dev bond0.29 up
ip -d link show bond0.29
 systemctl restart networking.service