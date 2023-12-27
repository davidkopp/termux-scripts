# Termux scripts for syncing Git repository

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

#### Accessing Termux from your computer (optional)

_If you set up remote access to Termux on your Android device, the following steps will be easier._

[Termux Remote Access](https://wiki.termux.com/wiki/Remote_Access)

Access your Termux session (you have to change the IP address):

```sh
ssh -p 8022 192.168.0.108
```

#### Accessing remote Git repository

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
cd termux-scripts
```

### Setup sync

_Note: The script `setup-git-repo.sh` changes some git configurations. If you want other options, modify it before executing it._

Make the scripts executable:

```sh
chmod +x *.sh
```

Execute `setup-scripts`:

```sh
./setup-scripts.sh
```

Execute the interactive script `setup-git-repo.sh` or provide some arguments (optional):

```sh
./setup-git-repo.sh path-to-repo branch-name
```

Example with real values:

```sh
./setup-git-repo.sh ~/storage/shared/git/notes main
```

Note: If you have a multi-repo setup, you have to provide the argument `path-to-repo` to all scripts. Use the second optional argument `branch` if you want to use another branch than `main` to synchronize.

Now you are finished with the setup inside of Termux. Exit Termux and open your launcher’s widget menu, select Termux:Widget and place the respective widget on your home screen.

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
        - Arguments (if you have a multi-repo setup): repo-path (see above)
        - ✔ Wait for result for commands
        - Timeout: 30 seconds

Mathis Gauthey has also published a great tutorial with some helpful screenshots: [How to Use Obsidian Git Sync on Android](https://mathisgauthey.github.io/how-to-use-obsidian-git-sync-on-android/)

As an alternative you can also setup a cronjob (see [here](https://forum.obsidian.md/t/guide-using-git-to-sync-your-obsidian-vault-on-android-devices/41887) for advice).

## Update script git-sync.sh

```sh
curl https://raw.githubusercontent.com/simonthum/git-sync/master/git-sync -o git-sync.sh
```
