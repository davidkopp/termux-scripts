#!/data/data/com.termux/files/usr/bin/bash

source $HOME/repo.conf
cd $HOME/storage/shared/$GH_REPO

git pull

bash -c "read -t 3 -n 1"
