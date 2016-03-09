#!/bin/bash
iperf -c 10.0.100.10 -p 443 &
iperf -c 10.0.100.11 -p 22 &
iperf -c 10.0.100.12 -p 25 &
wget http://10.0.100.13/wwwdata/something &


