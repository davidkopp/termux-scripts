# README

This repo includes scripts that are used in [Termux](https://termux.dev/) on my Android devices. Termux is an Android terminal emulator and Linux environment app.

The main purpose is to sync my [Obsidian](https://obsidian.md/) vault between devices via Git.

The idea to use Termux for automatic syncing came from [Rene Schallner](https://github.com/renerocksai): [Syncing your Obsidian vault to Android via an encrypted GitHub repository](https://renerocks.ai/blog/obsidian-encrypted-github-android/#shortcuts-for-committing-pushing-and-pulling)

For syncing I'm now using the script `git-sync.sh` by Simon Thum: [simonthum/git-sync](https://github.com/simonthum/git-sync)

## Setup

### Preparation

- Install [Tasker](https://tasker.joaoapps.com/download.html), [Termux](https://f-droid.org/en/packages/com.termux/), [Termux Widget](https://f-droid.org/en/packages/com.termux.widget/) and [Termux Tasker](https://f-droid.org/packages/com.termux.tasker/)
- Inside Termux, install some required packages:
    ```sh
    pkg update && pkg upgrade
    pkg install git openssh rsync
    ```
- Give Termux access to your storage ([Termux-setup-storage](https://wiki.termux.com/wiki/Termux-setup-storage)):
    ```sh
    termux-setup-storage
    ```

### Setup SSH

### Accessing Termux from your computer (optional)

_If you set up remote access to Termux on your Android device, the following steps will be easier._

[Termux Remote Access](https://wiki.termux.com/wiki/Remote_Access)

### Accessing remote Git repository

If you want to use SSH for accessing your remote Git repositories, create a new key pair:

```sh
ssh-keygen -t ed25519 -C "your optional comment"
eval "$(ssh-agent -s)" # start the ssh-agent in the background
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```

Copy the public key to your Git remote server (GitHub, ...).

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

Clone repos via SSH (e.g. your Obsidian vault located at GitHub):

```sh
cd ~/storage/shared
git clone git@github.com:YOUR_NAME/YOUR_REPO.git
```

The end result for me looks like that (you can choose other paths if you want):

- termux-scripts: `~/termux-scripts`
- Obsidian vault: `~/storage/shared/notes`

### Setup sync

_Note: The script `setup-git-repo.sh` changes some git configurations. If you want other options, modify it before executing it._

1. Make the setup scripts executable:
    ```sh
    chmod +x setup-scripts.sh
    chmod +x setup-git-repo.sh
    ```
2. Run setup scripts, setting `repo-path` to the relative path within ~ where the repository is checked out, and `branch` is your branch to synchronize (i.e. main or master)
    ```sh
    ./setup-scripts.sh
    ./setup-git-repo.sh repo-path branch
    ```

_Note: Creating symlinks in the `.shortcuts` directory that link to scripts outside of the directory are not allowed anymore (see [here](https://github.com/termux/termux-widget/issues/57))._

After exiting Termux, you can open your launcher’s widget menu, select Termux:Widget and place it on your home screen.

### Setup automatic sync

To automatically commit and sync changes I use the Termux add-on [Termux:Tasker](https://github.com/termux/termux-tasker).
My Tasker profile configuration (simplified):

- Trigger:
    - Every 1h
    - Wifi Connected
- Task "Git Sync":
    - Flash with text (e.g. "Git sync")
    - Termux:
        - Executable: `sync.sh`
        - Arguments: repo-path (as above)
        - ✔ Wait for result for commands
        - Timeout: 30 seconds

Mathis Gauthey has also published a great tutorial with some helpful screenshots: [How to Use Obsidian Git Sync on Android](https://mathisgauthey.github.io/how-to-use-obsidian-git-sync-on-android/)

As an alternative you can also setup a cronjob (see [here](https://forum.obsidian.md/t/guide-using-git-to-sync-your-obsidian-vault-on-android-devices/41887) for advice).

## Update script git-sync.sh

```sh
curl https://raw.githubusercontent.com/simonthum/git-sync/master/git-sync -o git-sync.sh
```
