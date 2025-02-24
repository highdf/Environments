#!/bin/python

import os
import sys
sys.path.append("/home/luky/Environments/Scripts/Meta/")
from meta import log, handle_error, exec_cmd, source_dict, is_resource


def clean_old_config(old_config_paths: dict[str, str]) -> None:
    log("Starting cleanup of old configuration files...")

    for file_name, path in old_config_paths.items():
        if os.path.exists(path):
            log(f"Removing old configure {file_name}")
            rmpath(path)
        log(f"Successfully removed: {file_name}")


def rmpath(path: str) -> None:
    if os.path.isdir(path):
        cmd = ["rm", "-rf", path]
        exec_cmd(cmd)
    elif os.path.isfile(path):
        cmd = ["rm", path]
        exec_cmd(cmd)
    else:
        handle_error(f"The {path} is exception")


def update_new_config(new_config_path: str,
                      old_config_paths: dict[str, str],
                      ) -> None:
    is_resource(new_config_path)
    log("Initializing new configure...")

    for new_config_file_name in os.listdir(new_config_path):
        new_config_file_path = os.path.join(new_config_path,
                                            new_config_file_name
                                            )
        target_path = old_config_paths[new_config_file_name]
        log(f"Initializing configure {new_config_file_name}")
        cmd = ["cp", "-r", new_config_file_path, target_path]
        exec_cmd(cmd)
        log(f"Initializing successfully: {new_config_file_name}")


def create_ln_zsh() -> None:
    cmd = [
        "sudo", "ln", "-s",
        "/usr/share/zsh-theme-powerlevel10k",
        "/usr/share/oh-my-zsh/themes/powerlevel10k",
    ]
    if os.path.islink(cmd[4]):
        log("Symbollic link already exists")
    else:
        log("Starting create symbolic link for zsh")
        exec_cmd(cmd)


def create_ssh_key() -> None:
    if os.path.isfile("/home/luky/.ssh/id_ed25519"):
        log("SSH key already exists")
    else:
        log("Starting create ssh key")
        cmd = ["ssh-keygen", "-t", "ed25519",
               "-N", "", "-f",
               "/home/luky/.ssh/id_ed25519"]
        exec_cmd(cmd)


def main() -> None:
    json_path = os.path.expanduser(
            "~/Environments/Configs/Static/source/backup_init_push_source.json"
    )
    old_config_paths = source_dict(json_path, "init_source")
    new_config_path = os.path.expanduser(
            "~/Environments/Configs/Dynamic"
    )

    clean_old_config(old_config_paths)
    update_new_config(new_config_path, old_config_paths)


if __name__ == "__main__":
    main()
