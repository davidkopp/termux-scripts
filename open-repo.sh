#!/data/data/com.termux/files/usr/bin/bash

# Variable 'GIT_REPO_PATH' must be set either by providing it via $HOME/repo.conf or by providing it as an argument to this script (e.g. `open-repo.sh ~/storage/shared/git/notes`)
if [[ $# -gt 0 ]]; then
  GIT_REPO_PATH=$1
elif [[ -e "$HOME/repo.conf" ]]; then
  # shellcheck source=repo.conf.example
  source "$HOME/repo.conf"
  if [[ -z "${GIT_REPO_PATH}" ]]; then
    echo 'Config file '"$HOME"/repo.conf' exists, but mandatory variable GIT_REPO_PATH is not set!'
    exit 1
  fi
fi

if [[ -z "${GIT_REPO_PATH}" ]]; then
  echo "Path to Git repository not provided! Usage: $(basename "$0") git-path"
  exit 1
fi

canonical_path_to_repo=$(readlink -f "${GIT_REPO_PATH/\~/$HOME}")
if [[ ! -d "${canonical_path_to_repo}" ]]; then
  echo "Provided path '${canonical_path_to_repo}' does not exist!"
  exit 1
fi

cd "${canonical_path_to_repo}" || (echo "cd into git dir failed!" && exit 1)

if [[ ! -d "$(git rev-parse --git-dir 2>/dev/null)" ]]; then
  echo "Provided path '${PWD}' is not a Git repository!"
  exit 1
fi

echo "Using git repository at ${canonical_path_to_repo}"
