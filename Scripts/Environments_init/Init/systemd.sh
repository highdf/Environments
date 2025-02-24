#! /bin/bash
source utils.sh

# Systemd launch
sleep $SLEEP_TIME
log "Config systemd"
systemctl --user enable --now pipewire
systemctl --user enable  --now wireplumber
sudo systemctl enable --now bluetooth
sudo systemctl enable --now libvirtd
sudo systemctl enable --now docker
sudo systemctl enable --now sshd

# USER 
if ! groups $USER | grep "docker" > /dev/null; then
	sudo usermod -aG docker $USER
fi
if ! groups $USER | grep "libvirt" > /dev/null; then
	sudo usermod -aG libvirt $USER
fi
log "User add groups successfully"

if [[ ! -e "$HOME/DownLoads" ]]; then
	mkdir "$HOME/DownLoads"
fi
