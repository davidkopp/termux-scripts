#!/data/data/com.termux/files/usr/bin/bash

if [[ $# != 2 ]]; then
  echo "Usage: $(basename $0) repo-path branch"
  exit 1
fi

GH_REPO=$1
BRANCH_NAME=$2

cd $HOME/storage/shared/$GH_REPO

# To avoid conflicts between Linux and Windows, set git file mode setting to false:
git config core.fileMode false

#Configure branch `main` for sync:
git config branch.${BRANCH_NAME}.sync true

# Automatically add new (untracked) files and sync them:
git config branch.${BRANCH_NAME}.syncNewFiles true

# Set commit message:
git config branch.${BRANCH_NAME}.syncCommitMsg "android on \$(printf '%(%Y-%m-%d %H:%M:%S)T\\n' -1)"
