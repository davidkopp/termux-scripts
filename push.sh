#!/data/data/com.termux/files/usr/bin/bash

if [[ $# != 1 ]]; then
	echo "Usage: $(basename $0) git-path"
	exit 1
fi

GH_REPO=$1

printf -v date '%(%Y-%m-%d %H:%M:%S)T\n' -1

cd $HOME/storage/shared/$GH_REPO

git add -A
git commit -m "android on $(date +%Y-%m-%d" "%H:%M:%S)"
git push

bash -c "read -t 3 -n 1"
