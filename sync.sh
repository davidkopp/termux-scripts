#!/data/data/com.termux/files/usr/bin/bash

source go-to-repo.sh $1

echo -e "Syncing repo '${PWD##*/}'...\n"
exec $HOME/termux-scripts/git-sync.sh
