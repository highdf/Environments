#! /bin/bash
source utils.sh

# Config ssh key
log "Configure ssh key"
ssh-keygen -t ed25519 -f ${HOME}/.ssh/id_ed25519
sleep $SLEEP_TIME

# github cli config ssh
log "Usage gh login github"
gh auth login

# Clone repo and config env
sleep $SLEEP_TIME
python ./Environments/Scripts/Environments_init/repo_clone.py || handle_error "Exec repo_clone.py failed"
python ./Environments/Scripts/Environments_init/config_init.py || handle_error "Exec config_init.py failed"
