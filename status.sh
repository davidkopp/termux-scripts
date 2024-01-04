#!/data/data/com.termux/files/usr/bin/bash

source "$HOME/open-repo.sh $1"

git status -v

# Wait for 5 seconds
bash -c "read -t 5 -n 1"
