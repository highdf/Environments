#!/bin/bash
DAILY_SCRIPT="/home/luky/Environments/Scripts/Daily_auto"

selected=$(find "${DAILY_SCRIPT}" -name "*.py" -printf "%f\n" | $1 --prompt-text "Script: ")

if [[ "" != "$selected" ]]; then
	kitty ${DAILY_SCRIPT}/${selected}
fi
