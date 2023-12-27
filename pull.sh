#!/data/data/com.termux/files/usr/bin/bash

source go-to-repo.sh $1

git pull

# Wait for 3 seconds
bash -c "read -t 3 -n 1"
