#!/data/data/com.termux/files/usr/bin/bash

# Ensure check if directory is safe is disabled, because in Termux we have a shared environment!
git config --global safe.directory '*'

# Set nano as default editor
git config --global core.editor "nano"

# To avoid conflicts between Linux and Windows, set git file mode setting to false:
git config core.fileMode false

# Configure branch for sync:
git config "branch.${BRANCH_NAME}.sync" true

# Automatically add new (untracked) files and sync them:
git config "branch.${BRANCH_NAME}.syncNewFiles" true

# Set commit message:
git config "branch.${BRANCH_NAME}.syncCommitMsg" "android on \$(printf '%(%Y-%m-%d %H:%M:%S)T\\n' -1)"

# Switch to provided branch
if ! git switch "${BRANCH_NAME}"; then
    echo "Switching to branch '${BRANCH_NAME}' failed! Check your configuration."
    exit 1
fi

# Set upstream
git branch --set-upstream-to="${REMOTE_NAME}/${BRANCH_NAME}"

# Finally try to fetch from remote
if ! git fetch "${REMOTE_NAME}"; then
    echo "Fetching from remote '${REMOTE_NAME}' failed! Check your configuration."
    exit 1
fi
