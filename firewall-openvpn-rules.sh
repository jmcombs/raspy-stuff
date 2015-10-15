#!/bin/sh

iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j SNAT --to-source 192.168.75.1 #IP ADDRESS OF RASPBERRY PI
