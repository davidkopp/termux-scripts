#!/data/data/com.termux/files/usr/bin/bash

if ! source "$HOME/open-repo.sh" "$1"
then
    echo "Open repo failed!"
    read -n 1 -s -r -t 10 -p "Press any key to exit"
fi

echo -e "Syncing repo '${PWD##*/}'...\n"
if ! exec "$HOME/termux-scripts/git-sync.sh"
then
    echo "Git sync failed with error code $?!"
    read -n 1 -s -r -t 10 -p "Press any key to exit"
fi
