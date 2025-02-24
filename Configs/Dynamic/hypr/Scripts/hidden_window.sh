#! /bin/bash

if [[ $# != 1 ]]; then
  echo "Usage  'hidden' or 'display_hidden_window'"
fi

if [[ $1 == "hidden" ]]; then
  hyprctl dispatch movetoworkspacesilent special:hidden
elif [[ $1 == "display_hidden_window" ]]; then
  temp_file=$(mktemp)
  current_workspace=$(hyprctl activeworkspace | awk '/workspace/ {print $3}')

  echo "current_workspace = ${current_workspace}"

  hyprctl clients | awk '
		START {
			line=0
			label=0
			count = 0
		}
		/Window/ {
			address=$2	
			line=NR
		}
		line+7 == NR && line != 0 {
			if ( $3 == "(special:hidden)" ) {
				printf "%d 0x%s ", count, address
				count ++;
				line = NR
				label=1
			}
		}
		 line+4 == NR && line != 0 && label == 1 {
			printf "%s %s\n", $1, $2
			label = 0
		}
	' >${temp_file}

  # echo "temp_file: "
  # cat ${temp_file}

  if [[ $(cat ${temp_file}) == "" ]]; then
    dunstify -a "Hidden_window" -u low -h string:x-dunst-stack-tag:"Hidden window" "Don't have hidden windows"
    exit 0
  fi

  select=$(awk '{printf "%d %s %s\n", $1, $3, $4}' ${temp_file} | tofi --prompt-text "Hidden Window: ")

  if [[ select -eq "" ]]; then
    exit
  fi

  target_number=$(echo "${select}" | awk '{printf "%d", $1}')

  target_address=$(awk -v number="${target_number}" '
		$1 == number {
			printf "%s", $2
		}	
	' ${temp_file})

  hyprctl dispatch movetoworkspace ${current_workspace},address:${target_address}
  echo "select = ${select}"
  echo "target_number = ${target_number}"
  echo "target_address = ${target_address}"
  rm ${temp_file}
fi
