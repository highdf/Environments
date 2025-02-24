#! /bin/bash
source utils.sh

while true; do
	read -p "Jump install yes/no : " flag

	if [[ "$flag" == "yes" || "$flay" == "no" ]]; then
		break;
	fi
done

# Install package
if [[ flag == "no" ]]; then
	log "Install package Git, Clash, Python..."
	sudo pacman --sync --noconfirm clash python git go|| handle_error "Install failed"
fi

# # Config init.sh
read -p "Please enter mount path of USB: " USB_DIR 
CONFIG_PATH="$USB_DIR/Init"
log "Starting config clash"
if [[ -e "${HOME}/.config/clash" ]]; then
	rm -rf "${HOME}/.config/clash"
fi
cp -r "$CONFIG_PATH/clash" "$HOME/.config/" || handle_error "Config clash failed"

# # Set proxy
sleep $SLEEP_TIME
log "Starting config proxy"
export http_proxy='http://127.0.0.1:7890'
export https_proxy='http://127.0.0.1:7890'
export HTTP_PROXY='http://127.0.0.1:7890'
export HTTPS_PROXY='http://127.0.0.1:7890'

# # Upen clash
if [[ -z "$(pgrep -x clash)" ]]; then
	log "Enable clash"
	clash &
	sleep 2
	if ! pgrep -x "clash" >/dev/null; then
		handle_error "Clash launch failed"
	fi
fi

# Run auto-install script
sleep $SLEEP_TIME
if [[ $1 == "no" ]]; then
	if [[ ! -e "$HOME/Environments" ]]; then
		log "Starting clone Environments..."
		git clone https://github.com/highdf/Environments.git "$HOME/Environments/" || handle_error "Clone failed..."
	fi
	./Environments/Scripts/Environments_init/auto_install.sh || handle_error "Exec auto_install.py failed"
fi
