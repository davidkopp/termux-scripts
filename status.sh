#!/data/data/com.termux/files/usr/bin/bash

source $HOME/repo.conf
cd $HOME/storage/shared/$GH_REPO

git status -v

bash -c "read -t 5 -n 1"
