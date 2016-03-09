#!/bin/bash
ifconfig h211-eth0.100:0 10.0.100.10 netmask 255.255.255.0
ifconfig h211-eth0.100:1 10.0.100.11 netmask 255.255.255.0
ifconfig h211-eth0.100:2 10.0.100.12 netmask 255.255.255.0
ifconfig h211-eth0.100:3 10.0.100.13 netmask 255.255.255.0
ifconfig h211-eth0.100:4 10.0.100.14 netmask 255.255.255.0
ifconfig h211-eth0.100:5 10.0.100.15 netmask 255.255.255.0
ifconfig h211-eth0.100:6 10.0.100.16 netmask 255.255.255.0
ifconfig h211-eth0.100:7 10.0.100.17 netmask 255.255.255.0
ifconfig h211-eth0.100:8 10.0.100.18 netmask 255.255.255.0
ifconfig h211-eth0.100:9 10.0.100.19 netmask 255.255.255.0
python -m SimpleHTTPServer 80 &
iperf -s &
