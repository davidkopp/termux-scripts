#!/data/data/com.termux/files/usr/bin/bash

# Arguments:
# $1: local path to git repo (required)
# $2: git branch name (optional, default "main")
# $3: repo name (optional, default extracted repo name, used as a suffix for script names)

GIT_REPO_PATH=$1
GIT_BRANCH_NAME=$2
REPO_NAME=$3

if [[ -z "${GIT_REPO_PATH}" ]]; then
  echo -e "Path to local Git repository not provided!\nUsage: $(basename "$0") git-path\nAs an alternative you can also use the interactive setup script: setup-interactive.sh"
  exit 1
fi
if [[ -z "${GIT_BRANCH_NAME}" ]]; then
  GIT_BRANCH_NAME=main
fi
if [[ -z "${REPO_NAME}" ]]; then
  REPO_NAME=$(basename "$GIT_REPO_PATH")
fi

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

###########################################

# First copy the latest version of open-repo.sh to home
cp "$MY_DIR/open-repo.sh" "$HOME/open-repo.sh"
chmod +x "$HOME/open-repo.sh"

# shellcheck source=open-repo.sh
if ! source "$HOME/open-repo.sh" "${GIT_REPO_PATH}"
then
  echo "Open repo '${GIT_REPO_PATH}' failed!"
  exit 1
fi

if [[ ! $(git branch --list "${GIT_BRANCH_NAME}") ]]; then
  echo "Git branch '${GIT_BRANCH_NAME}' does not exist!"
  exit 1
fi

# Configure git repository
source "$MY_DIR/configure-git.sh"

# Setup scripts for Termux:Widget and Termux:Tasker
rsync -a --delete "$MY_DIR/scripts/" "$MY_DIR/temp/"
cd "$MY_DIR/temp/" || exit 1
for file in *.sh; do
  sed -i "s|\$1|${GIT_REPO_PATH}|g" "$file"
  filename=$(basename "$file" .sh)
  new_filename="${filename}_${REPO_NAME}.sh"
  mv "$file" "$new_filename"
done

mkdir -p "$HOME/.shortcuts"
chmod 700 -R "$HOME/.shortcuts"
rsync -r "$MY_DIR/temp/" "$HOME/.shortcuts/"
chmod +x "$HOME"/.shortcuts/*.sh

mkdir -p "$HOME/.termux/tasker"
chmod 700 -R "$HOME/.termux"
rsync -r "$MY_DIR/temp/" "$HOME/.termux/"
chmod +x "$HOME"/.termux/tasker/*.sh

cd "$MY_DIR" || exit 1
rm -r "$MY_DIR/temp"

echo "Setup auto-sync of '${REPO_NAME}' was successful! (multi-repo setup)"
