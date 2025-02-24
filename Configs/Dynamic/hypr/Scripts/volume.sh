#! /bin/bash

if [[ $# != 1 ]]; then
	echo "Please usage \"value%+/-\" , \"value%\" or \"toggle\""
	exit 1
fi

msgTag="myvolume"

function volume() {
	wpctl set-volume @DEFAULT_SINK@ "$1" || echo "Set volume failed"
	local volume_info=$(wpctl get-volume @DEFAULT_SINK@)
	local mute_status=$(echo "${volume_info}" | awk '{print $3}')
	local volume=$(echo "${volume_info}" | awk '{print $2*100}')

	if [[ volume -gt 100 ]]; then
		wpctl set-volume @DEFAULT_SINK@ 1
		volume=100
	fi

	if [[ ! ("" == "${mute_status}") ]]; then
		dunstify -a "changevolume" -u low -i volume-mute -h string:x-dunst-stack-tag:${msgTag} "Volume Mute"
	else 
		# dunstify -a "changeVolume" -u low -h string:x-dunst-stack-tag:$msgTag \
		dunstify -a "changeVolume" -u low -i volume -h string:x-dunst-stack-tag:$msgTag \
		-h int:value:"${volume}" "Volume: ${volume}"
	fi

}
function mute() {
	wpctl set-mute @DEFAULT_SINK@ toggle
	local volume_info=$(wpctl get-volume @DEFAULT_SINK@)
	local mute_status=$(echo "${volume_info}" | awk '{print $3}')
	local volume=$(echo "${volume_info}" | awk '{print $2*100}')

	if [[ "" == "${mute_status}" ]]; then
		dunstify -a "changeVolume" -u low -i volume -h string:x-dunst-stack-tag:${msgTag} "Mute cancle"
	else 
		dunstify -a "changeVolume" -u low -i volume-mute -h string:x-dunst-stack-tag:${msgTag} "Muted"
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
