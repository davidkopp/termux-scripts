#!/data/data/com.termux/files/usr/bin/bash

BASE_REPO_PATH=~/storage/shared/git
if [[ $# > 0 ]]; then
  GIT_REPO_PATH=$1
  GIT_BRANCH_NAME=$2
fi

# Define function for git clone
gitclonecd() {
  git clone "$1"
  if [[ ! $? -eq 0 ]]; then
    echo "Git clone of '$1' failed with error code $?!"
    exit 1
  fi
  cd "$(basename "$1" .git)"
}

echo -e "Setup Git repository\n"

# First copy the required files to home
cp open-repo.sh $HOME/open-repo.sh
chmod +x $HOME/open-repo.sh
if [[ ! -d $HOME/repo.conf ]]; then
  cp repo.conf $HOME/repo.conf
fi

# Ensure git check if directory is safe is disabled, because in Termux we have a shared environment!
git config --global safe.directory '*'

# Use interactive mode if no repo path was provided via argument
if [[ -z "${GIT_REPO_PATH}" ]]; then
  echo "Do you want to clone a new repository (1) or provide a path to an already existing git repository on your device (2)?"
  read -p "Enter your choice (1 or 2): " choice

  case $choice in
      1)
          # Git clone
          if [[ -z "${GIT_REPO_URL}" ]]; then
            echo "Git clone URL (repo will be cloned to ${BASE_REPO_PATH}/REPO_NAME):"
            read GIT_REPO_URL
          fi
          mkdir -p ${BASE_REPO_PATH}
          cd ${BASE_REPO_PATH}
          REPO_NAME="$(basename "$GIT_REPO_URL" .git)"
          if [[ ! -d ${PWD}/${REPO_NAME} ]]; then
            gitclonecd ${GIT_REPO_URL}
            echo "Git repository cloned to: ${PWD}"
            GIT_REPO_PATH=${PWD}
          else
            GIT_REPO_PATH="${PWD}/${REPO_NAME}"
            echo "Directory ${GIT_REPO_PATH} already exists! Skip cloning of git repository ${GIT_REPO_URL}."
            cd ${GIT_REPO_PATH}
          fi
          ;;
      2)
          # Use existing local Git repository
          if [[ -z "${GIT_REPO_PATH}" ]]; then
            echo "Path to your local Git repository (full path required):"
            read GIT_REPO_PATH
          fi
          if [[ ! -d ${GIT_REPO_PATH} ]]; then
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

# Set repository as the default so it is used if no path is given as an argument to 'open-repo.sh' when executing the other scripts
sed -i "s|GIT_REPO_PATH=PATH_TO_REPO|GIT_REPO_PATH=${GIT_REPO_PATH}|" $HOME/repo.conf

# Get branch name, default is main
if [[ -z "${GIT_BRANCH_NAME}" ]]; then
  echo "Branch name for syncing (if none is provided, 'main' is used):"
  read GIT_BRANCH_NAME
  if [[ -z "${GIT_BRANCH_NAME}" ]]; then
    GIT_BRANCH_NAME=main
  fi
  if [[ ! `git branch --list ${GIT_BRANCH_NAME}` ]]; then
    echo "Git branch ${GIT_BRANCH_NAME} does not exist!"
    exit 1
  fi
fi

# To avoid conflicts between Linux and Windows, set git file mode setting to false:
git config core.fileMode false

#Configure branch `main` for sync:
git config branch.${GIT_BRANCH_NAME}.sync true

# Automatically add new (untracked) files and sync them:
git config branch.${GIT_BRANCH_NAME}.syncNewFiles true

# Set commit message:
git config branch.${GIT_BRANCH_NAME}.syncCommitMsg "android on \$(printf '%(%Y-%m-%d %H:%M:%S)T\\n' -1)"

echo "Setup git repository for syncing at '${GIT_REPO_PATH}' with branch '${GIT_BRANCH_NAME}' was successful!"
