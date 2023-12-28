#!/data/data/com.termux/files/usr/bin/bash

source $HOME/open-repo.sh $1

printf -v date '%(%Y-%m-%d %H:%M:%S)T\n' -1

git add -A
git commit -m "android on $(date +%Y-%m-%d" "%H:%M:%S)"
git push

# Wait for 3 seconds
bash -c "read -t 3 -n 1"
