#! /bin/bash

TARGET_DIR="$HOME/Pictures/Shot"
NUMBER=200
time=$((60 * 10))

while true; do
	files=$(find ${TARGET_DIR} -type f -printf "%f\n")
	# echo "$files"

	line_num=$(awk 'END { print NR }' <<<$files)
	# echo "$line_num"

	if [[ $line_num -gt $NUMBER ]]; then
		rm $TARGET_DIR/*
	fi
	sleep $time
done
