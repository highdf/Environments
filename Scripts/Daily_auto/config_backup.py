#! /bin/python3

import os
import sys
sys.path.append(os.path.expanduser("~/Environments/Scripts/Meta"))
from meta import log, handle_error, source_list, exec_cmd, is_resource


def rm_resource(path: str) -> None:
    cmd = ["rm", "-rf", path]
    exec_cmd(cmd)


def copy_resource(source_path: str, target_path: str) -> None:
    cmd = ["cp", "-r", source_path, target_path]
    exec_cmd(cmd)


def ispath_exist(path: str) -> None:
    if not os.path.exists(path):
        handle_error(f"{path} is not exist")


def clean_old_backup(target: str) -> None:
    log("Starting clean old backup")

    is_resource(target)

    for resource_name in os.listdir(target):
        resource_path = os.path.join(target, resource_name)
        rm_resource(resource_path)
        log(f"Successfully clean: {resource_name}")


def make_new_backup(source: list[str], target: str) -> None:
    log("Start make new backup")

    for resource_path in source:
        resource_path = os.path.expanduser(resource_path)
        is_resource(resource_path)
        resource_name = os.path.basename(resource_path)
        target_path = os.path.join(target, resource_name)
        copy_resource(resource_path, target_path)
        log(f"Successfully backup: {resource_name}")


def main() -> None:
    TARGET_DIR = os.path.expanduser("~/Environments/Configs/Dynamic")
    json_path = os.path.expanduser(
            "~/Environments/Configs/Static/source/backup_init_push_source.json"
    )
    SOURCE = source_list(json_path, "backup_source")
    log("Start update dynamic config")
    clean_old_backup(TARGET_DIR)
    make_new_backup(SOURCE, TARGET_DIR)


if __name__ == "__main__":
    main()
