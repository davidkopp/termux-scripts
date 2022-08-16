#!/data/data/com.termux/files/usr/bin/bash

source $HOME/repo.conf
cd $HOME/storage/shared/$GH_REPO

git pull

printf -v date '%(%Y-%m-%d %H:%M:%S)T\n' -1 
git add .
git commit -m "android on $(date +%Y-%m-%d" "%H:%M:%S)"
git push

git pull

cd $HOME
bash -c "read -t 3 -n 1"
