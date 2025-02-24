#! /bin/python

import os
# import subprocess
import sys
sys.path.append("/home/luky/Environments/Scripts/Meta/")
from meta import log, handle_error, exec_cmd, source_list


# def ispath_exist(path: str) -> bool:
#     return os.path.exists(path) and os.path.isdir(path)


# def verification(target_path: list[str]) -> None:
#     for path in target_path:
#         if ispath_exist(path):
#             handle_error(f"Path already exist: {path}")


def prompty(source: list[str], target_path: list[str]) -> None:
    log("Repository to be cloned")
    for urls, path in zip(source, target_path):
        path = os.path.expanduser(path)
        log(f"Repository URL: {urls} clone --> {path}")


def repo_clone(source: list[str], target_path: list[str]) -> None:
    for repo_url, path in zip(source, target_path):
        path = os.path.expanduser(path)

        if os.path.isdir(path):
            cmd = ["rm", "-rf", path]
            exec_cmd(cmd)
        log(f"\n--------->[ Start clone repository {repo_url} ]<---------")
        log("Cloneing...")
        cmd = ["git", "clone", repo_url, path]
        exec_cmd(cmd)
        log(f"--------->[ {repo_url} is success ]<---------")


def main() -> None:
    json_path = os.path.expanduser(
            "~/Environments/Configs/Static/source/clone.json"
    )
    SOURCE = source_list(json_path, "clone_url_source")
    TARGET_PATH = source_list(json_path, "clone_path_source")

    prompty(SOURCE, TARGET_PATH)
    repo_clone(SOURCE, TARGET_PATH)


if __name__ == "__main__":
    main()
