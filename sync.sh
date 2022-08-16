#!/data/data/com.termux/files/usr/bin/bash

source $HOME/repo.conf
cd $HOME/storage/shared/$GH_REPO

echo "Syncing ${PWD##*/}\n"
echo "1. Pull\n------\n"
git pull

echo "2. Commit new changes and push\n------\n"
printf -v date '%(%Y-%m-%d %H:%M:%S)T\n' -1 
git add .
git commit -m "android on $(date +%Y-%m-%d" "%H:%M:%S)"
git push

echo "3. Pull\n------\n"
git pull

echo "4. All done\n"

# Wait for Enter 
bash -c "read -t 3 -n 1"
