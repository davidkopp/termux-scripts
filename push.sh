#!/data/data/com.termux/files/usr/bin/bash

source $HOME/repo.conf
cd $HOME/storage/shared/$GH_REPO
git add .
git commit -m "android on $(date)"
git push
cd $HOME
bash -c "read -t 3 -n 1"
