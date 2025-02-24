#! /bin/bash

set -e

function handle_error() {
	echo "Error:$1"
	exit 1
}

# Install package
echo "Install package Git, Clash, Python..."
sudo pacman --sync --noconfirm clash python git || handle_error "Install failed"

# Config init.sh
read -p "Please enter mount path of USB: " USB_DIR 
CONFIG_PATH="$USB_DIR/Init"
echo "Starting config clash"
if [[ -e "${HOME}/.config/clash" ]]; then
	rm -rf "${HOME}/.config/clash"
fi
cp -r "$CONFIG_PATH/clash" "$HOME/.config/" || handle_error "Config clash failed"

# Set proxy
echo "Starting config proxy"
export http_proxy='http://127.0.0.1:7890'
export https_proxy='http://127.0.0.1:7890'
export HTTP_PROXY='http://127.0.0.1:7890'
export HTTPS_PROXY='http://127.0.0.1:7890'

# Upen clash
if [[ -z "$(pgrep -x clash)" ]]; then
	echo "Enable clash"
	clash &
	sleep 2
	if ! pgrep -x "clash" >/dev/null; then
		handle_error "Clash launch failed"
	fi
fi

# Run auto-install script
if [[ ! -e "$HOME/Environments" ]]; then
	echo "Starting clone Environments..."
	git clone https://github.com/highdf/Environments.git "$HOME/Environments/" || handle_error "Clone failed..."
fi
python ./Environments/Scripts/Environments_init/auto_install.py || handle_error "Exec auto_install.py failed"

# Config ssh key
echo "Configure ssh key"
ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_ed25519

# github cli config ssh
echo "Usage gh login github"
gh auth login

# Clone repo and config env
python ./Environments/Scripts/Environments_init/repo_clone.py || handle_error "Exec repo_clone.py failed"
python ./Environments/Scripts/Environments_init/config_init.py || handle_error "Exec config_init.py failed"

# Set tty font
if [ -e '/usr/share/kbd/consolefonts/ter-132n.psf.gz' ]; then
	echo "FONT=ter-132n" | tee -a /etc/vconsole.conf
else
	echo "Ter-132n font does not exist"
fi

# Set grub
sudo cp Environments/Configs/Static/Init/JetBrain.pf2 /boot/grub/fonts/JetBrain.pf2 || handle_error "Copy grub font failed"
sudo cp Environments/Configs/Static/Init/grub.cfg /boot/grub/grub.cfg || handle_error "Copy grub config failed"

# Clone Tmux plugin manager
echo "Install tmux plugin manager"
if [ ! -e "$HOME/.tmux" ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Set mime
if [ -e "$HOME/.config/mimeapps.list" ]; then
	rm "$HOME/.config/mimeapps.list"
fi
cp "$HOME/Environments/Configs/Static/Init/mimeapps.list" "$HOME/.config/mimeapps.list"

# Create zsh symbol link
echo "Create symbol link"
sudo ln -sf /usr/share/zsh-theme-powerlevel10k /usr/share/oh-my-zsh/themes/powerlevel10k

# Systemd launch
systemctl --user enable pipewire
systemctl --user enable wireplumber
sudo systemctl enable bluetooth

# clean file and directory
rm -rf yay || handle_error "Remove yay failed"
sudo umount -R $USB_DIR || handle_error "umount $USB_DIR failed"
rm -rf "$USB_DIR" || handle_error "rm $USB_DIR failed"
pacman --sync --clean --noconfirm || handle_error "Clean package cache failed"
