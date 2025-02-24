#!/bin/bash

limit=5
time=$((2))

while true; do
	capacity=$(cat /sys/class/power_supply/BAT0/capacity)
	status=$(cat /sys/class/power_supply/BAT0/status)

	if [[ "$status" == "Discharging" && ${capacity} -lt ${limit} ]]; then
		dunstify -r 10 -u critical -h string:x-dunst-stack-tag:battery "Battery capacity is less than ${limit}%"
	else
		dunstify -C 10
	fi

	sleep ${time}
done
