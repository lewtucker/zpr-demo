#!/bin/sh

# ip addr add 129.6.7.1/32 dev eth0

mkdir -p /var/run/zpr


ip tuntap add name tun8 mode tun multi_queue
ip link set tun8 mtu 1400
ip addr add fd5a:5052:90de::33/32 dev tun8
ip link set tun8 up


exec /app/bin/ph-no-uring node -c /authority/node-conf.toml
