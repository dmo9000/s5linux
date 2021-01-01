/sbin/ip addr add 192.168.20.52/24 dev eth0
/sbin/ip link set eth0 up
/sbin/ip route add 0.0.0.0/0 via 192.168.20.1

