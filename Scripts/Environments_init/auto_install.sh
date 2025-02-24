#! /bin/bash

DIR=$PWD
function log() {
	echo -e "\e[33m:: $1\e[0m"
}
function clean_yay() {
	local current_dir=$DIR
	if [[ -e "$current_dir/yay" ]]; then
		rm -rf "$current_dir/yay"
	fi
}
function handler_error() {
	log "Error: $1"
	clean_yay
	exit 1
}

log "Starting install pkglist"

base_dir="$HOME/Environments/Configs/Static/PkgList"

if [[ ! -e "/usr/bin/yay" ]]; then
	clean_yay
	git clone https://aur.archlinux.org/yay.git || handler_error "Yay clone failed"
	cd yay || handler_error "Yay clone failed"
	makepkg -si || handler_error "Yay clone failed"
fi

for pkg_dir in "Pacman" "Yay"; do
	target_dir=${base_dir}/${pkg_dir}
	# echo "target_dir = ${target_dir}"

	for file_name in ${target_dir}/*; do
		# suffix=$(awk -F '.' '{ print $2 }' <<< ${file_name})
		file_path=$file_name
		# echo "file_path = ${file_path}"

		log "Starting install ${file_path}"
		if [[ $pkg_dir == "Pacman" ]]; then
			sudo pacman --sync --noconfirm $(cat $file_path)
		elif [[ $pkg_dir == "Yay" ]]; then
			yay --sync --noconfirm $(cat $file_path)
		else
			log "Warning: $suffix failed"

		fi
		sleep 0
	done
done

clean_yay

log "Auto install successfully"
