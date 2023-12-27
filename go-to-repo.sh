#!/data/data/com.termux/files/usr/bin/bash

# Get repo name either by argument or use env var 'GH_REPO'
if [ -z "$1" ]; then
  GH_REPO=$1
elif [ -z "${GH_REPO+x}" ]; then
  echo "No argument provided and environment variable 'GH_REPO' is not set!"
  exit 1
fi

if [ ! git rev-parse --git-dir > /dev/null 2>&1 ]; then
    echo "Current directory '$PWD' is not a Git repository."
    exit 1
fi

cd $HOME/storage/shared/$GH_REPO
