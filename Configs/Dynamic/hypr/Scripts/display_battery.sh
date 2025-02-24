#! /bin/bash

msgTag="display_battery"

capacity=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

dunstify -a "display_battery" -u low -h string:x-dunst-stack-tag:$msgTag \
	-h int:value:"${capacity}" "Battery capacity: ${capacity}%"
