# Changelog

All notable changes to this project will be documented in this file.

## 2023-12-28

Breaking changes:

- Path provided in `repo.conf` through `GH_REPO` has changed from relative path to an absolute path and it was renamed to `GIT_REPO_PATH`. Example: GIT_REPO_PATH=~/storage/shared/git/notes

Changes:

- support for multi-repo setup
- enhance setup scripts to make the setup more user friendly
