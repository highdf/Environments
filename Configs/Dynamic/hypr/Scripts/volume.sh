#! /bin/bash

if [[ -z $1 || ! -z $2 ]]; then
	echo "Please usage \"value%+/-\" , \"value%\" or \"toggle\""
	exit 1
fi

msgTag="myvolume"

function icon_select() {
	if [[ $1 == "" ]]; then
		echo "notification-audio-volume-muted"
	elif [[ $1 -lt 30 ]]; then
		echo "notification-audio-volume-low"
	elif [[ $1 -lt 60 ]]; then
		echo "notification-audio-volume-medium"
	else 
		echo "notification-audio-volume-high"
	fi
}

function volume() {
	echo "$1"
	wpctl set-volume @DEFAULT_SINK@ "$1" || echo "Set volume failed"
	local volume_info=$(wpctl get-volume @DEFAULT_SINK@)
	local mute_status=$(echo "${volume_info}" | awk '{print $3}')
	local volume=$(echo "${volume_info}" | awk '{print $2*100}')

	if [[ volume -gt 100 ]]; then
		wpctl set-volume @DEFAULT_SINK@ 1
		volume=100
	fi

	local icon=$(icon_select ${volume})
	if [[ ! ("" == "${mute_status}") ]]; then
		dunstify -a "changevolume" -u low -i ${icon} -h string:x-dunst-stack-tag:${msgTag} "Volume Mute"
	else 
		dunstify -a "changeVolume" -u low -i ${icon} -h string:x-dunst-stack-tag:$msgTag \
		-h int:value:"${volume}" "Volume: ${volume}"
	fi

}
function mute() {
	wpctl set-mute @DEFAULT_SINK@ toggle
	local volume_info=$(wpctl get-volume @DEFAULT_SINK@)
	local mute_status=$(echo "${volume_info}" | awk '{print $3}')
	local volume=$(echo "${volume_info}" | awk '{print $2*100}')

	if [[ "" == "${mute_status}" ]]; then
		local icon=$(icon_select ${volume})
		dunstify -a "changeVolume" -u low -i ${icon} -h string:x-dunst-stack-tag:${msgTag} "Mute cancle"
	else 
		local icon=$(icon_select "")
		dunstify -a "changeVolume" -u low -i ${icon} -h string:x-dunst-stack-tag:${msgTag} "Muted"
	fi
}

function main() {
	if [[ $1 != "toggle" ]]; then
		volume $1
	else 
		mute $1
	fi
}

main $1
