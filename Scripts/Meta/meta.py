import os
import subprocess
import sys
import json
from typing import Any


def exec_cmd(cmd: list[str]) -> None:
    try:
        subprocess.run(
            cmd,
            check=True,
            stdin=subprocess.DEVNULL,
            stderr=subprocess.PIPE,
            text=True,
        )
    except FileNotFoundError:
        handle_error(f"'{cmd[0]} command is not found")
    except subprocess.CalledProcessError as e:
        handle_error(f"Failed run '{cmd[0]}':\nError details:{e.stderr}")


def log(message: str) -> None:
    print(f"{message}")


def handle_error(message: str) -> None:
    log(f"Error: {message}")
    sys.exit(1)


def source_list(json_path: str, field: str) -> list[str]:
    re = load_json(json_path, field)
    return re


def source_dict(json_path: str, field: str) -> dict[str, str]:
    re = load_json(json_path, field)
    return re


def load_json(json_path: str, field: str) -> Any:
    if not os.path.exists(json_path):
        handle_error(f"File {json_path} is not exist")

    try:
        with open(json_path, "r") as f:
            config = json.load(f)
    except json.JSONDecodeError as e:
        handle_error(f"Json load is failed:\nError details: {e.msg}")

    if not isinstance(config, dict):
        raise TypeError(f"JSON content is not a dictionary in {json_path}")
    if field not in config:
        raise KeyError(f"Field '{field}' not found in {json_path}")

    return config[field]


def is_resource(path: str) -> bool:
    if os.path.isfile(path) or os.path.isdir(path):
        re = True
    else:
        handle_error(f"Path {path} is not exist")

    return re
