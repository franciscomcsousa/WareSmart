#!/bin/bash

line=$(head -n 1 macaddress.secret)

while true
do
	timeout 10 bluetoothctl scan on | grep $line >> rssi.txt
	echo $(date +%s)  >> rssi.txt
done

# Get the list of discovered devices
# bluetoothctl devices

