#! /bin/python

import os
import subprocess
import sys
sys.path.append(os.path.expanduser("~/Environments/Scripts/Meta"))
from meta import log, handle_error, source_dict, exec_cmd


def prompt(repo: dict[str, str], branch: str) -> None:
    print("The following repositories and branches are about to be operated")

    print("Repositories infomation")
    for repo_name, repo_path in repo.items():
        repo_path = os.path.expanduser(repo_path)
        print(f"repository name : [{repo_name}]", end=" | ")
        print(f"repository path : [{repo_path}]")

    print("Branches name", end=" : ")
    for branch_name in branch:
        print(f"[{branch_name}]", end=" ")
    print()
    print("There will be a force push")


def confirm_operation(path: str) -> bool:
    re = True

    while True:
        response = input(f"===>Whether or no to push {path} [Y]es or [N]o: ").upper()
        if response in {"No", "N"}:
            re = False
            break
        elif response in {"Yes", "Y"}:
            break
    return re


def verification_repo(repo: dict[str, str]) -> None:
    for repo_name, repo_path in repo.items():
        repo_path = os.path.expanduser(repo_path)
        git_dir = os.path.join(repo_path, ".git")
        if not os.path.exists(repo_path):
            handle_error(f"Path {repo_path} is not exist")
        if not os.path.exists(git_dir):
            handle_error(f"Not exist .git in the {repo_path}")


def push_repository(repos: dict[str, str], branch: str) -> None:
    operation = [
        ["git", "add", "."],
        ["git", "commit", "--amend", "--no-edit"],
        ["git", "push", "--force", "origin", branch],
    ]

    prompt = [
        "stage success...",
        "Commit success...",
        "Push success...",
    ]
    for repo_name, repo_path in repos.items():
        if not confirm_operation(repo_path):
            log(f"[[Jumped the repository -> {repo_path}]]")
            continue
        log(f"Starting push [{repo_name}]")
        repo_path = os.path.expanduser(repo_path)
        os.chdir(repo_path)
        for cmd, message in zip(operation, prompt):
            try:
                subprocess.run(
                    cmd,
                    check=True,
                    # timeout=40,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE,
                    text=True,
                )
            except subprocess.CalledProcessError as e:
                handle_error(f"Git failed:\n{e.stderr}")
            # except subprocess.TimeoutExpired:
            #     handle_error("TimeOut")
            except FileNotFoundError:
                handle_error("Git command is not found")
            print(message)
    log("[[Push repository complete]]")


def main() -> None:
    source_path = os.path.expanduser(
            "~/Environments/Configs/Static/source/backup_init_push_source.json"
    )
    REPOS = source_dict(source_path, "push_source")
    BRANCH = "main"

    verification_repo(REPOS)
    prompt(REPOS, BRANCH)
    push_repository(REPOS, BRANCH)


if __name__ == "__main__":
    main()
