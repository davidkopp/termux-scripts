#!/data/data/com.termux/files/usr/bin/bash

# Get repo name either by argument or use env var 'GH_REPO'
if [ "$#" -eq 0 ]; then
  GH_REPO=$1
elif [ -z "${GH_REPO+x}" ]; then
    echo "No argument provided and environment variable 'GH_REPO' is not set!"
    exit 1
fi

cd $HOME/storage/shared/$GH_REPO
