#!/data/data/com.termux/files/usr/bin/bash

# Variable 'GIT_REPO_PATH' will be set by $HOME/repo.conf or by providing an argument (e.g. `open-repo.sh ~/storage/shared/git/notes`)
source $HOME/repo.conf

if [[ -n "$1" ]]; then
  GIT_REPO_PATH=$1
fi

if [[ -z "${GIT_REPO_PATH}" ]]; then
  echo "Variable GIT_REPO_PATH not set and no argument provided!"
  exit 1
fi

if [[ ! -d ${GIT_REPO_PATH} ]]; then
  echo "Directory ${GIT_REPO_PATH} does not exist!"
  exit 1
fi

cd ${GIT_REPO_PATH}

if [[ ! git rev-parse --git-dir > /dev/null 2>&1 ]]; then
  echo "Directory '${PWD}' is not a Git repository!"
  exit 1
fi

echo "Using git repository at ${GIT_REPO_PATH}"
