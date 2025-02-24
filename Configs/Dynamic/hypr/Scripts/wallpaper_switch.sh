#!/bin/bash

wallpaper_dir="$HOME/Pictures/screen"
wait_time=$((0))
time=$((60 * 10))
OPT=("outer" "grow" "simple" "fade" "left" "right" "top" "bottom" "wipe" "wave" "center" "none")

function random_switch() {
  local wall_paperarray=()
  local list=$(find "$1" -type f)

  while read file; do
    wall_paperarray+=("$file")
  done <<<"${list}"

  local random_index=$((RANDOM % ${#wall_paperarray[@]}))
  local tran_type_index=$((RANDOM % ${#OPT[@]}))
  wall_paper_file="${wall_paperarray[random_index]}"

  awww img -t ${OPT[${tran_type_index}]} "${wall_paper_file}"
  sed -i -e '/path = /{' -e 'c\' -e "    path = ${wall_paper_file}" -e '}' "$HOME/.config/hypr/hyprlock.conf"

  # dunstify -a "WallPaper_Switch" "WallPaper_Switch successfully"
}

function choose() {
  local day=${DAY_START}
  local night=${DAY_END}
  local current_time=$(date +%k)

  if [[ ${current_time} -ge ${day} && ${current_time} -lt ${night} ]]; then
    echo "Light"
  else
    echo "Night"
  fi
}

while true; do
  sleep "${wait_time}"
  dir="${wallpaper_dir}/$(choose)"

  if [[ ! -d $dir ]]; then
    echo "${dir} is not exsits"
  fi

  random_switch ${dir}
  sleep ${time}
done
