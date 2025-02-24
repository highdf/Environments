#! /bin/python

import os
import sys
import subprocess
sys.path.append("/home/luky/Environments/Scripts/Meta/")
from meta import log, handle_error, exec_cmd, is_resource


def prompt(path: str) -> None:
    log(f"Installing package from {path}")


def is_exist_dir(dir_path: str) -> bool:
    return os.path.exists(dir_path) and os.path.isdir(dir_path)


def is_exist_yay() -> bool:
    yay_path = [
            "/usr/bin/yay",
            os.path.expanduser("~/.local/bin/yay"),
    ]
    re = False

    for path in yay_path:
        if os.path.exists(path):
            re = True
            break
    return re


def install_yay() -> None:
    log("Installing yay")
    source_dir = os.getcwd()
    yay_dir = os.path.join(source_dir, "yay")

    cmd = ["git", "clone", "https://aur.archlinux.org/yay.git"]
    log("Cloneing yay")
    # subprocess.run(cmd, check=True, stderr=subprocess.PIPE, text=True)
    exec_cmd(cmd)
    log("Clone completed")

    # subprocess.run(["tar", "xvf", "yay.tar.gz"], check=True)
    os.chdir(yay_dir)
    log("Start installing yay")
    cmd = ["makepkg", "-si",]
    # subprocess.run(cmd, check=True, stderr=subprocess.PIPE, text=True)
    exec_cmd(cmd)
    log("Install completed")


def run_cmd(pkg_manager: str, pkglist_path: str) -> None:
    if pkg_manager == "pacman":
        base_cmd = ["sudo", pkg_manager]
    elif pkg_manager == "yay":
        base_cmd = [pkg_manager]

    cmd = base_cmd + ["--sync", "--noconfirm", "-"]
    try:
        with open(pkglist_path, "r") as f:
            subprocess.run(
                cmd,
                check=True,
                stdin=f,
                stderr=subprocess.PIPE,
                text=True,
            )
    except subprocess.CalledProcessError as e:
        handle_error(f"{e.stderr}")


def install(pkglist_dir: str) -> None:
    is_resource(pkglist_dir)

    package_manager = ["pacman", "yay"]
    log("Please usage root install")
    for pkglist_file in os.listdir(pkglist_dir):
        pkglist_path = os.path.join(pkglist_dir, pkglist_file)
        prompt(pkglist_path)

        suffix = os.path.splitext(pkglist_file)[1]
        if suffix == ".pacman":
            run_cmd(package_manager[0], pkglist_path)
        elif suffix == ".yay":
            if not is_exist_yay():
                log("Warning: Yay not exist")
                install_yay()
            run_cmd(package_manager[1], pkglist_path)
        else:
            handle_error("file {pkglist_path} is error")
    log("Starting clean yay...")
    cmd = ["rm", "-rf", "yay"]
    exec_cmd(cmd)


def main() -> None:
    PKGLIST_DIR = "/home/luky/Environments/Configs/Static/PkgList/"
    install(PKGLIST_DIR)


if __name__ == "__main__":
    main()
