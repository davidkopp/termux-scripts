#!/data/data/com.termux/files/usr/bin/bash

# Get repo name either by argument or use env var 'GH_REPO'
if [ -e "$HOME/repo.conf" ]; then
  source $HOME/repo.conf
elif [ -n "$1" ]; then
  GH_REPO=$1
elif [ -z "${GH_REPO}" ]; then
  echo "No argument provided and file 'repo.conf' in your home directory does not exist!"
  exit 1
fi

cd $HOME/storage/shared/$GH_REPO

if [ ! git rev-parse --git-dir > /dev/null 2>&1 ]; then
    echo "Directory '$PWD' is not a Git repository!"
    exit 1
fi
