#!/data/data/com.termux/files/usr/bin/bash

# Create mandadory directory
mkdir -p $HOME/.shortcuts
chmod 700 -R $HOME/.shortcuts

# Copy scripts
rsync -a --include='log.sh' --include='pull.sh' --include='push.sh' --exclude '*' $HOME/termux-scripts/ $HOME/.shortcuts
