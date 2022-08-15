#!/data/data/com.termux/files/usr/bin/bash

# -- Termux:Widget --

# Create mandadory directory
mkdir -p $HOME/.shortcuts
chmod 700 -R $HOME/.shortcuts

# Copy scripts
rsync -a --include='log.sh' --include='pull.sh' --include='push.sh' --include='sync.sh' --exclude '*' $HOME/termux-scripts/ $HOME/.shortcuts

chmod +x $HOME/.shortcuts/*.sh

# -- Termux:Tasker --

# Create mandadory directory
mkdir -p $HOME/.termux/tasker
chmod 700 -R $HOME/.termux

# Copy scripts
rsync -a --include='log.sh' --include='pull.sh' --include='push.sh' --include='sync.sh' --exclude '*' $HOME/termux-scripts/ $HOME/.termux/tasker

chmod +x $HOME/.termux/tasker/*.sh
