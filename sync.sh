#!/data/data/com.termux/files/usr/bin/bash

if [[ $# != 1 ]]; then
	echo "Usage: $(basename $0) git-path"
	exit 1
fi

GH_REPO=$1

cd $HOME/storage/shared/$GH_REPO

echo -e "Syncing repo '${PWD##*/}'...\n"
source $HOME/termux-scripts/git-sync.sh
