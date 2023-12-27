#!/data/data/com.termux/files/usr/bin/bash

#GIT_REPO_PATH=PATH_TO_REPO

if [ -n "$1" ]; then
  GIT_REPO_PATH=$1
else
  echo "Variable GIT_REPO_PATH not set and no argument provided!"
  exit 1
fi

echo "Use git repo path: ${GIT_REPO_PATH}"

cd ${GIT_REPO_PATH}

if [ ! git rev-parse --git-dir > /dev/null 2>&1 ]; then
    echo "Directory '${PWD}' is not a Git repository!"
    exit 1
fi
