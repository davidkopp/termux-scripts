#!/data/data/com.termux/files/usr/bin/bash

# Default path used for cloning a new repository
BASE_PATH_FOR_REPO_CLONING="$HOME/storage/shared/git"

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Do you want to clone a new repository (1) or provide a path to an already existing git repository on your device (2)?"
read -p "Enter your choice (1 or 2): " choice
case $choice in
  1)
    # Clone a new git repository
    canonical_base_path=$(readlink -f "${BASE_PATH_FOR_REPO_CLONING}")
    echo "Git clone URL (repo will be cloned to '${canonical_base_path}/REPO_NAME'):"
    read GIT_REPO_URL
    echo ""
    mkdir -p "${canonical_base_path}"
    cd "${canonical_base_path}" || (echo "cd ${canonical_base_path} failed!" && exit 1)
    REPO_NAME="$(basename "$GIT_REPO_URL" .git)"
    GIT_REPO_PATH=$(readlink -f "${PWD}/${REPO_NAME}")
    if [[ -d $GIT_REPO_PATH ]]; then
      echo "Directory '${GIT_REPO_PATH}' already exists! Skip cloning of git repository ${GIT_REPO_URL}. Try to use existing directory instead."
    else
      if ! git clone "$GIT_REPO_URL"; then
        echo "Git clone of '$GIT_REPO_URL' failed!"
        exit 1
      fi
      echo "Git repository cloned to: ${GIT_REPO_PATH}"
    fi
    ;;
  2)
    # Use an existing local Git repository
    echo "Path to your local Git repository (full path required):"
    read path_to_repo
    canonical_path_to_repo=$(readlink -f "${path_to_repo/\~/$HOME}")
    if [[ ! -d "${canonical_path_to_repo}" ]]; then
      echo "Provided git repo path '${canonical_path_to_repo}' does not exist!"
      exit 1
    fi
    GIT_REPO_PATH=$canonical_path_to_repo
    ;;
  *)
    echo "Invalid choice. Please enter 1 or 2."
    exit 1
    ;;
esac

# Ask for branch name, default is main
if [[ -z "${GIT_BRANCH_NAME}" ]]; then
echo -e "\nWhich branch do you want to use for syncing? (if none is provided, 'main' is used)"
read GIT_BRANCH_NAME
fi

# Single or multi repo setup?
echo -e "Do you want to setup sync for only one repository or for multiple ones?\nOne: (1)\nMultiple: (2)"
read -p "Enter your choice (1 or 2): " choice
case $choice in
  1)
    source "$MY_DIR/setup-single-repo.sh" "${GIT_REPO_PATH}" "${GIT_BRANCH_NAME}"
    ;;
  2)
    source "$MY_DIR/setup-multi-repo.sh" "${GIT_REPO_PATH}" "${GIT_BRANCH_NAME}"
    ;;
esac
