#!/data/data/com.termux/files/usr/bin/bash

if [[ $# != 1 ]]; then
	echo "Usage: $(basename $0) git-path"
	exit 1
fi

GH_REPO=$1

cd $HOME/storage/shared/$GH_REPO

git log

bash -c "read -t 5 -n 1"
