#!/bin/bash
iperf -c 10.0.100.10
iperf -c 10.0.100.11
iperf -c 10.0.100.12
wget http://10.0.100.13/wwwdata/something

