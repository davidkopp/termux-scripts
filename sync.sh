#!/data/data/com.termux/files/usr/bin/bash

source $HOME/repo.conf
cd $HOME/storage/shared/$GH_REPO

echo -e "Syncing repo '${PWD##*/}'...\n"
echo -e "1. Pull\n"
git pull

echo -e "\n2. Commit new changes and push\n"
printf -v date '%(%Y-%m-%d %H:%M:%S)T\n' -1 
git add .
git commit -m "android on $(date +%Y-%m-%d" "%H:%M:%S)"
git push

echo -e "\n3. Pull\n"
git pull

echo -e "\n4. All done\n"

# Wait for Enter 
bash -c "read -t 3 -n 1"
