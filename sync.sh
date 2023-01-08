#!/data/data/com.termux/files/usr/bin/bash

source $HOME/repo.conf
cd $HOME/storage/shared/$GH_REPO

echo -e "Syncing repo '${PWD##*/}'...\n"
source $HOME/termux-scripts/git-sync.sh
