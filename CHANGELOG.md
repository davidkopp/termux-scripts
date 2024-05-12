# Changelog

All notable changes to this project will be documented in this file.

## 2024-05-12

- big refactoring of the setup scripts: now three different scripts are provided you can choose from

## 2024-01-08

- many bug fixes related to using and checking the path to a git repo

## 2023-12-28

Breaking changes:

- Path provided in `repo.conf` through `GH_REPO` has changed from relative path to an absolute path and it was renamed to `GIT_REPO_PATH`. Example: GIT_REPO_PATH=~/storage/shared/git/notes

Changes:

- support for multi-repo setup
- enhance setup scripts to make the setup more user friendly
