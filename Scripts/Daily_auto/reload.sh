#! /bin/bash

function handle_error() {
	echo "Error: $1"
	exit 1
}

fcitx5 -r &>/dev/null &
echo "Successfully reload for fcitx5"

kitty @ load-config || handle_error "Kitty reload failed"
echo "Successfully reload for kitty"

if pgrep -x waybar &> /dev/null ; then
	pkill waybar || handle_error "Reload waybar failed"
fi
waybar &> /dev/null &
echo "Successfully reload for waybar"
