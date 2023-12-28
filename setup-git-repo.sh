#!/data/data/com.termux/files/usr/bin/bash

echo "Setup Git repository\n"

gitclonecd() {
  git clone "$1"
  if [[! $? -eq 0 ]]; then
    echo "Git clone of '$1' failed with error code $?!"
    exit 1
  fi
  cd "$(basename "$1" .git)"
}

if [[ $# > 0 ]]; then
  GIT_REPO_PATH=$1
  GIT_BRANCH_NAME=$2
else
  echo "Do you want to clone a new repository (1) or provide a path to an already existing git repository on your device (2)?"
  read -p "Enter your choice (1 or 2): " choice

  case $choice in
      1)
          if [[ -z "${GIT_REPO_URL}" ]]; then
            echo "URL to your Git repository for cloning (will be cloned to ~/storage/shared/git/REPO_NAME):"
            read GIT_REPO_URL
          fi
          mkdir -p ~/storage/shared/git
          cd ~/storage/shared/git
          REPO_NAME="$(basename "$GIT_REPO_URL" .git)"
          if [[ ! -d "${PWD}/${REPO_NAME}" ]]; then
            gitclonecd ${GIT_REPO_URL}
            echo "Git repository cloned to: ${PWD}"
            GIT_REPO_PATH=${PWD}
          else
            GIT_REPO_PATH="${PWD}/${REPO_NAME}"
            echo "Directory ${GIT_REPO_PATH} already exists! Skip cloning of git repository ${GIT_REPO_URL}."
          fi
          ;;
      2)
          if [[ -z "${GIT_REPO_PATH}" ]]; then
            echo "Path to your local Git repository (full path required):"
            read GIT_REPO_PATH
          fi
          if [[ ! -d "${GIT_REPO_PATH}" ]]; then
            echo "Provided git repo path '${GIT_REPO_PATH}' does not exist!"
            exit 1
          fi
          cd ${GIT_REPO_PATH}
          ;;
      *)
          echo "Invalid choice. Please enter 1 or 2."
          exit 1
          ;;
  esac
fi

echo "Repository '${GIT_REPO_PATH}' will be used for syncing."
# Repository is set as the default to be opened if no path is given as an argument to 'open-repo.sh'
sed -i 's/#GIT_REPO_PATH=PATH_TO_REPO/GIT_REPO_PATH=${GIT_REPO_PATH}/' $HOME/open-repo.sh

if [[ -z "${GIT_BRANCH_NAME}" ]]; then
  echo "Branch name for syncing (default main):"
  read GIT_BRANCH_NAME
  if [[ -z "${GIT_BRANCH_NAME}" ]]; then
    GIT_BRANCH_NAME=main
fi

# To avoid conflicts between Linux and Windows, set git file mode setting to false:
git config core.fileMode false

#Configure branch `main` for sync:
git config branch.${GIT_BRANCH_NAME}.sync true

# Automatically add new (untracked) files and sync them:
git config branch.${GIT_BRANCH_NAME}.syncNewFiles true

# Set commit message:
git config branch.${GIT_BRANCH_NAME}.syncCommitMsg "android on \$(printf '%(%Y-%m-%d %H:%M:%S)T\\n' -1)"
