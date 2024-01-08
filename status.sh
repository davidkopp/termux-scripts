#!/data/data/com.termux/files/usr/bin/bash

if ! source "$HOME/open-repo.sh" "$1"
then
    echo "Open repo failed!"
    read -n 1 -s -r -t 10 -p "Press any key to exit"
fi

git status -v

# Wait for user input so the user is able see the status
read -n 1 -s -r -p "Press any key to exit"
