#!/data/data/com.termux/files/usr/bin/bash

# Variable 'GIT_REPO_PATH' must be set either by providing it via $HOME/repo.conf or by providing it as an argument to this script (e.g. `open-repo.sh ~/storage/shared/git/notes`)
echo "open repo..."
if [[ -e "$HOME/repo.conf" ]]; then
  # shellcheck source=repo.conf.example
  source "$HOME/repo.conf"
  echo "Configured path to git repo: ${GIT_REPO_PATH}"
  if [[ -z "${GIT_REPO_PATH}" ]]; then
    echo 'Config file '"$HOME"/repo.conf' exists, but mandatory variable GIT_REPO_PATH is not set!'
    exit 1
  fi
else
  if [[ $# != 1 ]]; then
    echo "Path to Git repository not provided! Usage: $(basename "$0") git-path"
    exit 1
  fi
  GIT_REPO_PATH=$1
fi

if [[ ! -d "${GIT_REPO_PATH}" ]]; then
  echo "Provided path '${GIT_REPO_PATH}' does not exist!"
  exit 1
fi

cd "${GIT_REPO_PATH}" || echo "cd into git dir failed!" && exit 1

if [[ ! -d "$(git rev-parse --git-dir 2>/dev/null)" ]]; then
  echo "Provided path '${PWD}' is not a Git repository!"
  exit 1
fi

echo "Using git repository at ${GIT_REPO_PATH}"
