if [[ $# -ne 1 ]]; then
	echo "Usage: $0 \"value%+/-\""
	exit 1
fi

msgTag="light"

if ! brightnessctl set "$1"; then
	dunstify -a "changelight" -u critical "Error: Failed to set brightness"
	exit 1
fi

light_value=$(brightnessctl info | awk -F '[()%]' '/Current/ {print $2}')

icon=brightness

dunstify -a "changelight" -u low -i ${icon} \
	-h string:x-dunst-stack-tag:${msgTag} \
	-h int:value:${light_value} \
	"Brightness: ${light_value}%"
