#!/data/data/com.termux/files/usr/bin/bash

# Default path used for cloning a new repository
BASE_PATH_FOR_REPO_CLONING=~/storage/shared/git

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# First copy the latest version of open-repo.sh to home
cp "$SCRIPTS_DIR/open-repo.sh" "$HOME/open-repo.sh"
chmod +x "$HOME/open-repo.sh"

if [[ -e "$HOME/repo.conf" ]]; then
  # If repo.conf already exists, try to use it → single-repo setup
  echo 'Config file '"$HOME"/repo.conf' already exists. Try to use it ...'
  if grep -q "GH_REPO" "$HOME/repo.conf"; then
    echo 'Warning: File '"$HOME"/repo.conf' is using an outdated format! Consider deleting it ("rm ~/repo.conf") and rerun this script!'
    exit 1
  fi
  # shellcheck source=open-repo.sh
  if ! source "$HOME/open-repo.sh"
  then
      echo "Open repo failed!"
      exit 1
  fi
elif [[ $# -gt 0 ]]; then
  # If arguments are provided, use them → multi-repo setup
  GIT_REPO_PATH=$1
  GIT_BRANCH_NAME=$2
  # shellcheck source=open-repo.sh
  if ! source "$HOME/open-repo.sh" "${GIT_REPO_PATH}"
  then
    echo "Open repo '${GIT_REPO_PATH}' failed!"
    exit 1
  fi
else
  # If config file '$HOME/repo.conf' doesn't exist and no arguments are provided, ask the user what to do → single-repo setup
  echo "Do you want to clone a new repository (1) or provide a path to an already existing git repository on your device (2)?"
  read -p "Enter your choice (1 or 2): " choice
  case $choice in
      1)
          # Clone a new git repository
          if [[ -z "${GIT_REPO_URL}" ]]; then
            echo "Git clone URL (repo will be cloned to ${BASE_PATH_FOR_REPO_CLONING}/REPO_NAME):"
            read GIT_REPO_URL
          fi
          mkdir -p ${BASE_PATH_FOR_REPO_CLONING}
          cd ${BASE_PATH_FOR_REPO_CLONING} || echo "cd ${BASE_PATH_FOR_REPO_CLONING} failed!" && exit 1
          REPO_NAME="$(basename "$GIT_REPO_URL" .git)"
          GIT_REPO_PATH="${PWD}/${REPO_NAME}"
          if [[ -d $GIT_REPO_PATH ]]; then
            echo "Directory ${GIT_REPO_PATH} already exists! Skip cloning of git repository ${GIT_REPO_URL}."
          else
            if ! git clone "$GIT_REPO_URL"
            then
              echo "Git clone of '$GIT_REPO_URL' failed with error code $?!"
              exit 1
            fi
            echo "Git repository cloned to: ${GIT_REPO_PATH}"
          fi
          ;;
      2)
          # Use an existing local Git repository
          if [[ -z "${GIT_REPO_PATH}" ]]; then
            echo "Path to your local Git repository (full path required):"
            read GIT_REPO_PATH
          fi
          if [[ ! -d ${GIT_REPO_PATH} ]]; then
            echo "Provided git repo path '${GIT_REPO_PATH}' does not exist!"
            exit 1
          fi
          ;;
      *)
          echo "Invalid choice. Please enter 1 or 2."
          exit 1
          ;;
  esac

  # Create config file for single-repo setup
  cp "${SCRIPTS_DIR}/repo.conf.example" "$HOME/repo.conf"
  sed -i "s|GIT_REPO_PATH=|GIT_REPO_PATH=${GIT_REPO_PATH}|" "$HOME/repo.conf"

  # Try to open repo
  # shellcheck source=open-repo.sh
  source "$HOME/open-repo.sh"

  # Ask for branch name, default is main
  if [[ -z "${GIT_BRANCH_NAME}" ]]; then
    echo -e "\nWhich branch do you want to use for syncing? (if none is provided, 'main' is used)"
    read GIT_BRANCH_NAME
  fi
fi

if [[ -z "${GIT_BRANCH_NAME}" ]]; then
  GIT_BRANCH_NAME=main
fi
if [[ ! $(git branch --list "${GIT_BRANCH_NAME}") ]]; then
  echo "Git branch '${GIT_BRANCH_NAME}' does not exist!"
  exit 1
fi

# Ensure git check if directory is safe is disabled, because in Termux we have a shared environment!
git config --global safe.directory '*'

# To avoid conflicts between Linux and Windows, set git file mode setting to false:
git config core.fileMode false

#Configure branch `main` for sync:
git config "branch.${GIT_BRANCH_NAME}.sync" true

# Automatically add new (untracked) files and sync them:
git config "branch.${GIT_BRANCH_NAME}.syncNewFiles" true

# Set commit message:
git config "branch.${GIT_BRANCH_NAME}.syncCommitMsg" "android on \$(printf '%(%Y-%m-%d %H:%M:%S)T\\n' -1)"

echo "Setup git repository for syncing at '${GIT_REPO_PATH}' with branch '${GIT_BRANCH_NAME}' was successful!"
