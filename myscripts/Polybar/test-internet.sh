#!/bin/bash

status_file="/tmp/net_connection_status"
con_status="false"
connection=false

# Reading previous status
if [ -f $status_file ]; then
    con_status=$(cat $status_file)
else
	echo "false" > $status_file
	con_status=$(cat $status_file)
fi

# Getting current status
#ping_output=$(ping -c 5 8.8.8.8 2>&1)
packet_loss="N/A"
packet_loss=$(ping -c 5 192.168.0.1 2>&1 | grep -oP "\d+(?=% packet loss)")
ping_exit_status=$?

if [ "$ping_exit_status" -eq 0 ]; then
	if [ "$packet_loss" -lt 50 ]; then
		connection=true
	fi
fi

# Check if wifi is connected or not

if [ "$con_status" = "true" ] && [ "$connection" = false ]; then
	dunstify "No Internet" "Packet loss: ${packet_loss}%" --icon=/usr/share/icons/Archcraft-Dark/status/22/network-limited.svg
	echo "false" > $status_file
elif [ "$con_status" = "false" ] && [ "$connection" = true ]; then
	dunstify "Internet connected"
	echo "true" > $status_file
fi
