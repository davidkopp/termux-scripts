#!/data/data/com.termux/files/usr/bin/bash

source $HOME/repo.conf
cd $HOME/storage/shared/$GH_REPO

echo -e "Syncing ${PWD##*/}\n"
echo -e "1. Pull\n------\n"
git pull

echo -e "2. Commit new changes and push\n------\n"
printf -v date '%(%Y-%m-%d %H:%M:%S)T\n' -1 
git add .
git commit -m "android on $(date +%Y-%m-%d" "%H:%M:%S)"
git push

echo -e "3. Pull\n------\n"
git pull

echo -e "4. All done\n"

# Wait for Enter 
bash -c "read -t 3 -n 1"
