#!/data/data/com.termux/files/usr/bin/bash

source $HOME/repo.conf
cd $HOME/storage/shared/$GH_REPO

# To avoid conflicts between Linux and Windows, set git file mode setting to false:
git config core.fileMode false

#Configure branch `main` for sync:
git config branch.main.sync true

# Automatically add new (untracked) files and sync them:
git config branch.main.syncNewFiles true

# Set commit message:
git config branch.main.syncCommitMsg "android on \$(printf '%(%Y-%m-%d %H:%M:%S)T\\n' -1)"
