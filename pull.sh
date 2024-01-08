#!/data/data/com.termux/files/usr/bin/bash

if ! source "$HOME/open-repo.sh" "$1"
then
    echo "Open repo failed!"
    read -n 1 -s -r -t 10 -p "Press any key to exit"
fi

git pull

# Wait some seconds so the user is able see what was done
read -n 1 -s -r -t 5 -p "Press any key to exit"
