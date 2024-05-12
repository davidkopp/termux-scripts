#!/data/data/com.termux/files/usr/bin/bash

# Arguments:
# $1: local path to git repo (only required, if ~/repo.conf does not exist yet)
# $2: git branch name (optional, default "main")

GIT_REPO_PATH=$1
GIT_BRANCH_NAME=$2

if [[ -z "${GIT_BRANCH_NAME}" ]]; then
  GIT_BRANCH_NAME=main
fi

###########################################

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# First copy the latest version of open-repo.sh to home
cp "$MY_DIR/open-repo.sh" "$HOME/open-repo.sh"
chmod +x "$HOME/open-repo.sh"

# If repo.conf already exists, try to use it
if [[ -e "$HOME/repo.conf" ]]; then
  echo 'Config file '"$HOME"/repo.conf' already exists. Try to use it ...'
  if grep -q "GH_REPO" "$HOME/repo.conf"; then
    echo 'Warning: File '"$HOME"/repo.conf' is using an outdated format! Consider deleting it ("rm ~/repo.conf") and rerun this script!'
    exit 1
  fi

  # shellcheck source=open-repo.sh
  if ! source "$HOME/open-repo.sh"
  then
      echo "Open repo with path defined in '"$HOME"/repo.conf' failed!"
      exit 1
  fi
# Otherwise create new config file
elif [[ -n "${GIT_REPO_PATH}" ]]; then
  cp "${MY_DIR}/repo.conf.example" "$HOME/repo.conf"
  sed -i "s|GIT_REPO_PATH=|GIT_REPO_PATH=${GIT_REPO_PATH}|" "$HOME/repo.conf"

  # shellcheck source=open-repo.sh
  if ! source "$HOME/open-repo.sh" "${GIT_REPO_PATH}"
  then
    echo "Open repo '${GIT_REPO_PATH}' failed!"
    exit 1
  fi
else
  echo -e "Path to local Git repository not provided!\nUsage: $(basename "$0") git-path\nAs an alternative you can also use the interactive setup script: setup-interactive.sh"
  exit 1
fi

if [[ ! $(git branch --list "${GIT_BRANCH_NAME}") ]]; then
  echo "Git branch '${GIT_BRANCH_NAME}' does not exist!"
  exit 1
fi

# Configure git repository
source "$MY_DIR/configure-git.sh"

# Setup scripts for Termux:Widget
mkdir -p "$HOME/.shortcuts"
chmod 700 -R "$HOME/.shortcuts"
rsync -r "$MY_DIR/scripts/" "$HOME/.shortcuts"
chmod +x "$HOME"/.shortcuts/*.sh

# Setup scripts for Termux:Tasker
mkdir -p "$HOME/.termux/tasker"
chmod 700 -R "$HOME/.termux"
rsync -r "$MY_DIR/scripts/" "$HOME/.termux"
chmod +x "$HOME"/.termux/*.sh
chmod +x "$HOME"/.termux/tasker/*.sh

REPO_NAME=$(basename "$GIT_REPO_PATH")

echo "Setup auto-sync of '${REPO_NAME}' was successful! (single-repo setup)"
