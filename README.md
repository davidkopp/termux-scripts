# Termux scripts for syncing Git repositories

This repo includes scripts to simplify the setup of syncing Git repositories on Android devices using [Termux](https://termux.dev/). Termux is an Android terminal emulator and Linux environment app.

The original purpose for me was to auto-sync my [Obsidian](https://obsidian.md/) vault between devices with Git.

The idea to use Termux for automatic syncing came from [Rene Schallner](https://github.com/renerocksai): [Syncing your Obsidian vault to Android via an encrypted GitHub repository](https://renerocks.ai/blog/obsidian-encrypted-github-android/#shortcuts-for-committing-pushing-and-pulling)

For syncing I'm now using the script `git-sync.sh` by Simon Thum: [simonthum/git-sync](https://github.com/simonthum/git-sync)

## Why use Termux?

There are many ways to sync git repositories with Android devices. However, in my experience, this setup with git inside the Termux environment is the most flexible and reliable.

Alternatives:

- Obsidian community plugin [Obsidian Git](https://github.com/denolehov/obsidian-git): Great on desktop, but the mobile version has some [limitations](https://github.com/denolehov/obsidian-git#mobile) that make it a bad choice for me.
- Android app [MGit](https://github.com/maks/MGit/): No auto-sync in the background possible, has problems with storage permissions (see [issue 620](https://github.com/maks/MGit/issues/620)).
- Android app [GitJournal](https://github.com/GitJournal/GitJournal): No auto-sync in the background possible.
- [Syncthing](https://syncthing.net/): Generally a great solution for syncing! However, in my opinion you shouldn't use Syncthing to sync a Git repository. Also, I don't like having a file synced multiple times in the background while I'm editing it.

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

Start OpenSSH server in Termux:

```sh
sshd
```

Access your Termux session from another device (change the IP address to the address of your device, e.g. use `ifconfig`):

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

_Note: During the setup some changes are made to your git configuration. If you want other options, modify the script 'configure-git.sh'._

First ensure that all scripts are executable:

```sh
chmod +x *.sh
```

You can choose between the three different ways of setting up your repository/repositories:

- Interactive mode (`setup-interactive.sh`)
  - provides the possibility to clone a Git repository
  - can also be used if a local Git repository already exists
  - can be used for both, single-repo setup and multi-repo setup
- Single-repo setup (`setup-single-repo.sh`)
  - Git repository has to already exist locally
  - path to this single repo is stored in a config file called `repo.conf` in your home directory
- Multi-repo setup (`setup-multi-repo.sh`)
  - Git repository has to already exist locally
  - no central config file, path to the respective repository must be provided as an argument for each script later on (e.g. `sync.sh ~/storage/shared/git/notes`)

#### Single-repo setup

Single-repo setup means that you only have one Git repository that you want to sync. The path to this single repo is stored in a config file called `repo.conf` in your home directory.

You can either use an interactive mode (`setup-interactive.sh`) or directly provide the required parameters as arguments to the script `setup-single-repo.sh`.

```sh
./setup-single-repo.sh path-to-repo branch-name
```

Arguments:

- `path-to-repo`: local path to git repo (required)
- `branch-name`: git branch name (optional, default "main")

Example with real values:

```sh
./setup-single-repo.sh ~/storage/shared/git/notes main
```

Now you are done with the setup in Termux.

You can now open your launcher's widget menu, select Termux:Widget and place the widget for a script on your home screen. If you want to setup automatic sync for a repository see the section [Setup automatic sync](#setup-automatic-sync) below.

#### Multi-repo setup

Multi-repo setup means that you have multiple Git repositories that you want to sync.
The path to a single repository must be provided as an argument for each script later on (e.g. `sync.sh ~/storage/shared/git/notes`).

You can either use an interactive mode (`setup-interactive.sh`) or directly provide the required parameters as arguments to the script `setup-multi-repo.sh`.

```sh
./setup-multi-repo.sh path-to-repo branch-name repo-name
```

Arguments:

- `path-to-repo`: local path to git repo (required)
- `branch-name`: git branch name (optional, default "main")
- `repo-name`: name used as a suffix for script names (optional, if not provided the name of the repo is used)

Example with real values:

```sh
./setup-multi-repo.sh ~/storage/shared/git/notes main notes
```

Now you are done with the setup of one repository. If you want to setup another repository, just repeat the same steps and provide a different path to the script.

You can now open your launcher's widget menu, select Termux:Widget and place the widget for a script on your home screen. If you want to setup automatic sync for a repository see the section [Setup automatic sync](#setup-automatic-sync) below.

### Setup automatic sync

To automatically commit and sync changes I use the Termux add-on [Termux:Tasker](https://github.com/termux/termux-tasker).

Tasker profile configuration (simplified):

- Trigger:
    - Every 1h
    - Wifi Connected
- Task "Git Sync":
    - Flash with text (e.g. "Git sync")
    - Termux:
        - Executable: `sync.sh`
        - Arguments (not used anymore, was used in the past to provide a path in a multi-repo setup)
        - ✔ Wait for result for commands
        - Timeout: 30 seconds

Mathis Gauthey has also published a great tutorial with some helpful screenshots: [How to Use Obsidian Git Sync on Android](https://mathisgauthey.github.io/how-to-use-obsidian-git-sync-on-android/)

As an alternative you can also setup a cronjob (see [here](https://forum.obsidian.md/t/guide-using-git-to-sync-your-obsidian-vault-on-android-devices/41887) for advice).
