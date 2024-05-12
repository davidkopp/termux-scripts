#!/data/data/com.termux/files/usr/bin/bash

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
