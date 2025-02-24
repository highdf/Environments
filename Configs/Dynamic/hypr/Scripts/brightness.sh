if [[ $# -ne 1 ]]; then
    echo "Usage: $0 \"value%+/-\""
    exit 1
fi

function icon_select() {
	if [[ $1 -lt 30 ]]; then
		echo "notification-display-brightness-low"
	elif [[ $1 -lt 60 ]]; then
		echo "notification-display-brightness-medium"
	else 
		echo "notification-display-brightness-full"
	fi
}

msgTag="light"  # 修复变量名拼写错误

# 设置亮度并捕获错误
if ! brightnessctl set "$1"; then
    dunstify -a "changelight" -u critical "Error: Failed to set brightness"
    exit 1
fi

light_value=$(brightnessctl info | awk -F '[()%]' '/Current/ {print $2}')

icon=$(icon_select ${light_value})

dunstify -a "changelight" -u low -i ${icon} \
    -h string:x-dunst-stack-tag:${msgTag} \
    -h int:value:${light_value} \
    "Brightness: ${light_value}%"
