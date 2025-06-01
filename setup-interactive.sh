#!/data/data/com.termux/files/usr/bin/bash

# Default paths used for cloning a new repository
BASE_PATH_GIT_BARE_REPOS="$HOME"
BASE_PATH_GIT_WORKTREE_MAIN="$HOME/storage/shared/git"

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Do you want to clone a new repository (1) or provide a path to an already existing git repository on your device (2)?"
read -p "Enter your choice (1 or 2): " choice
case $choice in
  1)
    # Clone a new git repository (add bare repo in local storage and worktree in shared storage)
    canonical_base_path_bare_repos=$(readlink -f "${BASE_PATH_GIT_BARE_REPOS}")
    canonical_base_path_worktree=$(readlink -f "${BASE_PATH_GIT_WORKTREE_MAIN}")
    echo "Git clone URL:"
    read GIT_REPO_URL
    echo ""

    REPO_NAME="$(basename "$GIT_REPO_URL" .git)"
    BARE_REPO_NAME="${REPO_NAME}.git"
    mkdir -p "${canonical_base_path_bare_repos}"
    cd "${canonical_base_path_bare_repos}" || (echo "cd ${canonical_base_path_bare_repos} failed!" && exit 1)
    GIT_BARE_REPO_PATH=$(readlink -f "${PWD}/${BARE_REPO_NAME}")
    mkdir -p "${canonical_base_path_worktree}"
    cd "${canonical_base_path_worktree}" || (echo "cd ${canonical_base_path_worktree} failed!" && exit 1)
    GIT_WORKTREE_PATH=$(readlink -f "${PWD}/${REPO_NAME}")

    echo "The repo '${GIT_REPO_URL}' will be cloned as a bare repository to '${GIT_BARE_REPO_PATH}' and the worktree will be placed in '${GIT_WORKTREE_PATH}'."
    if [[ -d $GIT_BARE_REPO_PATH ]]; then
      echo "Directory '${GIT_BARE_REPO_PATH}' already exists! Cloning of the git repository will be skipped and the existing directory will be used instead."
    fi
    if [[ -d $GIT_WORKTREE_PATH ]]; then
      echo "Directory '${GIT_WORKTREE_PATH}' already exists! Adding worktree will be skipped. This is probably not intended and the setup probably won't work!"
    fi
    read -r -p "Continue? [Y/n] " response
    response=${response,,}
    if [[ "$response" == "n" ]]; then
        echo "Exiting."
        exit 1
    fi
    echo ""

    # clone the repository as a bare repo
    if ! [[ -d $GIT_BARE_REPO_PATH ]]; then
      cd "${canonical_base_path_bare_repos}" || (echo "cd ${canonical_base_path_bare_repos} failed!" && exit 1)
      if ! git clone --bare "$GIT_REPO_URL" "$BARE_REPO_NAME"; then
        echo "Git clone of '$GIT_REPO_URL' failed!"
        exit 1
      fi
      cd "${GIT_BARE_REPO_PATH}" || (echo "cd ${GIT_BARE_REPO_PATH} failed!" && exit 1)
      # workaround: by default bare repos don't fetch remote branches
      git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    fi
    echo ""
    # create main worktree in detached mode (we don't want to create a new branch)
    if ! [[ -d $GIT_WORKTREE_PATH ]]; then
      if ! git worktree add --detach "${GIT_WORKTREE_PATH}"; then
        echo "Add worktree for bare repository '${GIT_BARE_REPO_PATH}' in '${GIT_WORKTREE_PATH} failed!"
        exit 1
      fi
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
    GIT_WORKTREE_PATH=$canonical_path_to_repo
    ;;
  *)
    echo "Invalid choice. Please enter 1 or 2."
    exit 1
    ;;
esac

# Ask for branch name, default is main
if [[ -z "${BRANCH_NAME}" ]]; then
  echo -e "\nWhich branch do you want to use for syncing? (if none is provided, 'main' is used)"
  read BRANCH_NAME
fi

# Single or multi repo setup?
echo -e "Do you want to setup sync for only one repository or for multiple ones?\nOne: (1)\nMultiple: (2)"
read -p "Enter your choice (1 or 2): " choice
case $choice in
  1)
    source "$MY_DIR/setup-single-repo.sh" "${GIT_WORKTREE_PATH}" "${BRANCH_NAME}"
    ;;
  2)
    source "$MY_DIR/setup-multi-repo.sh" "${GIT_WORKTREE_PATH}" "${BRANCH_NAME}"
    ;;
esac
