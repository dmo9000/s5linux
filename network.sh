ip addr add 192.168.20.52/24 dev eth0
ip link set eth0 up
ip route add 0.0.0.0/0 via 192.168.20.1

