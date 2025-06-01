# Changelog

All notable changes to this project will be documented in this file.

## 2025-06-01

Use [git-worktree](https://git-scm.com/docs/git-worktree) to be able to place the git repository in the local Termux storage and the worktree in the shared storage. This avoid filesystem issues using Git.
To be able to use this new feature I recommend to run the script `setup-interactive.sh" and clone the repository/repositories again.

## 2024-05-12

Big refactoring of the setup scripts: now three different scripts are provided you can choose from.

Breaking change:
In a multi-repo setup the scripts get renamed using the name of the git repo (e.g. `sync.sh` -> `sync_notes.sh`). Therefore the widgets and tasks inside of Tasker may have to be modified accordingly.
There should be no breaking change in a single-repo setup.

## 2024-01-08

- many bug fixes related to using and checking the path to a git repo

## 2023-12-28

Breaking changes:

- Path provided in `repo.conf` through `GH_REPO` has changed from relative path to an absolute path and it was renamed to `GIT_REPO_PATH`. Example: GIT_REPO_PATH=~/storage/shared/git/notes

Changes:

- support for multi-repo setup
- enhance setup scripts to make the setup more user friendly
