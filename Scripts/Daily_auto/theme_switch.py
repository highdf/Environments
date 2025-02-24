#! /bin/python

import os
import sys
import random
import subprocess
from datetime import datetime
sys.path.append(os.path.expanduser("~/Environments/Scripts/Meta/"))
from meta import log, handle_error, exec_cmd, source_list, is_resource


DAY = int(os.getenv("DAY_START"))
NIGHT = int(os.getenv("DAY_END"))
current_time = datetime.now().hour


def reload() -> None:
    cmd = ["reload.sh"]
    try:
        subprocess.run(
                cmd,
                shell=True,
                stderr=subprocess.PIPE,
                check=True,
        )
    except subprocess.CalledProcessError as e:
        handle_error(f"Run reload failed:\nError details:{e.stderr}")
    except FileNotFoundError:
        handle_error("Script does not found")


def choose_theme(theme: list[str]) -> str:
    if DAY <= current_time < NIGHT:
        theme_file = theme[0]
    else:
        theme_file = theme[1]
    return theme_file


def copy_switch(
        theme_path: str,
        target_path: str,
        theme_groups: list[list[str]],
        name: str
        ) -> None:
    theme = random.choice(theme_groups)

    is_resource(theme_path)
    is_resource(target_path)

    theme_file = choose_theme(theme)
    theme_file_path = os.path.join(theme_path, theme_file)
    log(f"Usage theme: {theme_file} in the {name}")
    cmd = ["cp", theme_file_path, target_path]
    exec_cmd(cmd)


def sed_switch(
        theme_path: str,
        target_path: str,
        theme_groups: list[list[str]],
        name: str
        ) -> None:
    theme = random.choice(theme_groups)

    is_resource(theme_path)
    is_resource(target_path)

    theme_file = choose_theme(theme)
    theme_file_path = os.path.join(theme_path, theme_file)
    cmd_clear = ["sed", "-i", "/THEME/q", target_path]
    exec_cmd(cmd_clear)
    log(f"Usage theme: {theme_file} in the dunst")
    cmd = ["sed", "-i", f"/THEME/r {theme_file_path}", target_path]
    exec_cmd(cmd)


def sed_change(
        target_path: str,
        theme_text: list[str],
        name: str,
        ) -> None:
    is_resource(target_path)

    theme = choose_theme(theme_text)
    log(f"Usage theme: {theme} in the {name}")
    cmd = [
            "sed", "-i", "-e", "/THEME/{", "-e", "n",
            "-e", "c\\", "-e", f"{theme}", "-e", "}",
            f"{target_path}",
    ]
    exec_cmd(cmd)


def parse_json(json_path: str) -> None:
    target_fields = source_list(json_path, "item")

    for field in target_fields:
        config = source_list(json_path, field)
        if field in ["kitty", "waybar"]:
            copy_switch(
                    os.path.expanduser(config[0]),
                    os.path.expanduser(config[1]),
                    config[2],
                    field,
            )
        elif field in ["dunst", "tofi"]:
            sed_switch(
                    os.path.expanduser(config[0]),
                    os.path.expanduser(config[1]),
                    config[2],
                    field,
            )
        else:
            sed_change(
                    os.path.expanduser(config[0]),
                    config[1],
                    field,
            )


def main() -> None:
    json_path = os.path.expanduser(
            "~/Environments/Configs/Static/source/theme_source.json"
    )

    parse_json(json_path)
    # reload()


if __name__ == "__main__":
    main()
