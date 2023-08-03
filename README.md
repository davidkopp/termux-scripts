# README

This repo includes scripts that are used in [Termux](https://termux.dev/) on my Android devices. Termux is an Android terminal emulator and Linux environment app.

The main purpose is to sync my [Obsidian](https://obsidian.md/) vault between devices via Git.

The idea to use Termux for automatic syncing came from [Rene Schallner](https://github.com/renerocksai): [Syncing your Obsidian vault to Android via an encrypted GitHub repository](https://renerocks.ai/blog/obsidian-encrypted-github-android/#shortcuts-for-committing-pushing-and-pulling)

For syncing I'm now using the script `git-sync.sh` by Simon Thum: [simonthum/git-sync](https://github.com/simonthum/git-sync)

## Setup

### Preparation

-   Install required packages:
    ```sh
    pkg install git openssh rsync
    ```
-   Setup storage: [Termux-setup-storage](https://wiki.termux.com/wiki/Termux-setup-storage)

### Setup SSH

SSH access to Termux from your computer (optional, but makes it much easier): [Remote Access](https://wiki.termux.com/wiki/Remote_Access)

If you want to use SSH for accessing your remote Git repositories, create a new key pair:

```sh
ssh-keygen -t ed25519 -C "your optional comment"
eval "$(ssh-agent -s)" # start the ssh-agent in the background
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

Copy the public key to your Git remove server (GitHub, ...).

### Setup git

```sh
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

Clone this repo inside Termux:

```sh
cd ~
git clone https://github.com/davidkopp/termux-scripts.git
```

Clone repos via SSH (e.g. your Obsidian vault):

```sh
cd ~/storage/shared
git clone git@github.com:YOUR_NAME/YOUR_REPO.git
```

The end result for me looks like that (you can choose other paths if you want):

-   termux-scripts: `~/termux-scripts`
-   Obsidian vault: `~/storage/shared/notes`

### Setup sync

_Note: The script `setup-git-repo.sh` makes some configurations. If you want other options, modify it before executing it._

1. Copy `repo.conf` from `termux-scripts` to the home directory inside Termux and edit it to your personal needs:
    ```sh
    cp repo.conf $HOME/repo.conf
    nano $HOME/repo.conf
    ```
2. Make the setup scripts executable:
    ```sh
    chmod +x setup-scripts.sh
    chmod +x setup-git-repo.sh
    ```
3. Run setup scripts
    ```sh
    ./setup-scripts.sh
    ./setup-git-repo.sh
    ```

_Note: Creating symlinks in the `.shortcuts` directory that link to scripts outside of the directory are not allowed anymore (see [here](https://github.com/termux/termux-widget/issues/57))._

After exiting Termux, you can open your launcher’s widget menu, select Termux:Widget and place it on your home screen.
To automatically commit and sync changes I use the Termux add-on [Termux:Tasker](https://github.com/termux/termux-tasker).
As an alternative you can also setup a cronjob (see [here](https://forum.obsidian.md/t/guide-using-git-to-sync-your-obsidian-vault-on-android-devices/41887) for advice).

## Update script git-sync.sh

```sh
curl https://raw.githubusercontent.com/simonthum/git-sync/master/git-sync -o git-sync.sh
```
