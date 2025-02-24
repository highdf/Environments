#! /bin/bash

###########
## utils ##
###########
SLEEP_TIME=2
function log() {
  echo -e "\e[33m:: $1\e[0m"
}
function handle_error() {
  log "Error: $1"
  exit 1
}

###########
## read  ##
###########
while true; do
  read -p "Jump install yes/no : " flag

  echo "flag = ${flag}"
  if [[ "$flag" == "yes" || "$flag" == "no" ]]; then
    break
  fi
done

######################
## install package  ##
######################
if [[ ${flag} == "no" ]]; then
  log "Install package Git, Clash, Python..."
  sudo pacman --sync --noconfirm clash python git go || handle_error "Install failed"
fi

####################
## Config init.sh ##
####################
read -p "Please enter mount path of USB: " USB_DIR

CONFIG_PATH="${PWD}/${USB_DIR}/Init"

log "CONFIG_PATH = ${CONFIG_PATH}"
log "Starting config clash"
if [[ ! -e "${HOME}/.config" ]]; then
  mkdir ${HOME}/.config
fi
if [[ -e "${HOME}/.config/clash" ]]; then
  log "Remove clash..."
  rm -rf "${HOME}/.config/clash"
fi
cp -r "$CONFIG_PATH/clash" "$HOME/.config/" || handle_error "Config clash failed"
log "Copy clash to .config/"

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
  sleep 5
  if ! pgrep -x "clash" >/dev/null; then
    handle_error "Clash launch failed"
  fi
  log "Clash launch sucessfully"
fi

#############################
## Run auto-install script ##
#############################

sleep $SLEEP_TIME
if [[ $flag == "no" ]]; then
  if [[ ! -e "$HOME/Environments" ]]; then
    log "Starting clone Environments..."
    git clone https://github.com/highdf/Environments.git "$HOME/Environments/" || handle_error "Clone failed..."
  fi
  ./Environments/Scripts/Environments_init/auto_install.sh || handle_error "Exec auto_install.py failed"
  log "Auto_install.py execute sucessfulyy"
fi

# ####################
# ## Config ssh key ##
# ####################
log "Configure ssh key"
ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_ed25519
sleep $SLEEP_TIME

# github cli config ssh
log "Usage gh login github"
gh auth login

# ###############################
# ## Clone repo and config env ##
# ###############################
sleep $SLEEP_TIME
python ./Environments/Scripts/Environments_init/repo_clone.py || handle_error "Exec repo_clone.py failed"
python ./Environments/Scripts/Environments_init/config_init.py || handle_error "Exec config_init.py failed"

# ##################
# ## Set tty font ##
# ##################
if ! grep "FONT=ter-132n" '/etc/vconsole.conf'; then
  sudo echo "FONT=ter-132n" | sudo tee -a /etc/vconsole.conf >/dev/null
else
  log "Updateed tty fonts"
fi

# Set grub
sleep $SLEEP_TIME
log "Grub install"
sudo cp Environments/Configs/Static/Init/JetBrain.pf2 /boot/grub/fonts/JetBrain.pf2 || handle_error "Copy grub font failed"
if ! grep "GRUB_FONT=" /etc/default/grub; then
  echo "GRUB_FONT=\"/boot/grub/fonts/JetBrain.pf2\"" |
    sudo tee -a /etc/default/grub
fi
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Clone Tmux plugin manager
log "Install tmux plugin manager"
if [ ! -e "$HOME/.tmux" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Set mime
sleep $SLEEP_TIME
if [ -e "$HOME/.config/mimeapps.list" ]; then
  rm "$HOME/.config/mimeapps.list"
fi
cp "$HOME/Environments/Configs/Static/Init/mimeapps.list" "$HOME/.config/mimeapps.list"

# Create zsh symbol link
log "Create symbol link"
sudo ln -sf /usr/share/zsh-theme-powerlevel10k /usr/share/oh-my-zsh/themes/powerlevel10k

# Font refransh
sleep $SLEEP_TIME
fc-cache -fv

# docker pull archlinux
if [[ ! -e /etc/docker ]]; then
  sudo mkdir /etc/docker
fi

if [[ ! -e /etc/docker/daemon.json ]]; then
  sudo tee /etc/docker/daemon.json <<-'EOF'
	{
		"registry-mirrors": [
		"https://dockercf.jsdelivr.fyi",
		"https://docker.jsdelivr.fyi",
		"https://dockertest.jsdelivr.fyi",
		"https://docker.1ms.run",
		"https://hub.rat.dev",
		"https://docker.1panel.live",
		"https://docker.zhai.cm",
		"https://a.ussh.net"
		]
	}
EOF
fi

# mariadb install
if ! sudo ls /var/lib/postgres &>/dev/null; then
  suod -iu postgres initdb /var/lib/postgres/data
fi

# Systemd launch
sleep $SLEEP_TIME
log "Config systemd"
systemctl --user enable --now pipewire
systemctl --user enable --now wireplumber
sudo systemctl enable --now bluetooth
sudo systemctl enable --now libvirtd
sudo systemctl enable --now docker
sudo systemctl enable --now sshd
sudo systemctl enable --now postgresql.service

# USER
if ! groups $USER | grep "docker" >/dev/null; then
  sudo usermod -aG docker $USER
fi
if ! groups $USER | grep "libvirt" >/dev/null; then
  sudo usermod -aG libvirt $USER
fi
log "User add groups successfully"

if [[ ! -e "$HOME/DownLoads" ]]; then
  mkdir "$HOME/DownLoads"
fi
