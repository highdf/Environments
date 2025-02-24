#! /bin/bash
source utils.sh

# Set tty font
if ! grep "FONT=ter-132n" '/etc/vconsole.conf'; then
	sudo echo "FONT=ter-132n" | sudo tee -a /etc/vconsole.conf > /dev/null
else
	log "Updateed tty fonts"
fi

# Set grub
sleep $SLEEP_TIME
log "Grub install"
sudo cp Environments/Configs/Static/Init/JetBrain.pf2 /boot/grub/fonts/JetBrain.pf2 || handle_error "Copy grub font failed"
if ! grep "GRUB_FONT=" /etc/default/grub; then
	echo "GRUB_FONT=\"/boot/grub/fonts/JetBrain.pf2\"" | \
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
if ! sudo ls /var/lib/mysql/mysql/{user,db}.frm &>/dev/null; then
	sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
if
