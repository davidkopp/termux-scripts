# Termux scripts for syncing Git repositories

This repo includes scripts that are used with [Termux](https://termux.dev/) on my Android devices. Termux is an Android terminal emulator and Linux environment app.

The main purpose is to sync my [Obsidian](https://obsidian.md/) vault between devices via Git.

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

_Note: The script `setup-git-repo.sh` changes some git configurations. If you want other options, modify it before executing it._

Make the scripts executable:

```sh
chmod +x *.sh
```

Execute `setup-scripts` to copy all required scripts to the correct locations:

```sh
./setup-scripts.sh
```

The script `setup-git-repo.sh` sets up a Git repository for syncing.

**Single-repo setup:**

Single-repo setup means that you only have one Git repository that you want to sync. The path to the repo gets stored in the config file `repo.conf` in your home directory.

- Either prepare the config file `repo.conf` in your home directory (change `PLACE_HERE_THE_PATH` to the actual path to your git repo):

  ```sh
  cp repo.conf.example $HOME/repo.conf
  sed -i "s|GIT_REPO_PATH=|GIT_REPO_PATH=PLACE_HERE_THE_PATH|" $HOME/repo.conf
  ./setup-git-repo.sh
  ```

- Or use interactive mode:

  ```sh
  ./setup-git-repo.sh
  ```

Now you are finished with the setup inside of Termux. Exit Termux and open your launcher’s widget menu, select Termux:Widget and place the respective widget on your home screen.

**Multi-repo setup:**

Multi-repo setup means that you have multiple Git repository that you want to sync.
The path to the respective repository must be provided as an argument for each script later on (e.g. `sync.sh ~/storage/shared/git/notes`).
There must be no file `repo.conf` in your home directory, otherwise the path configured in the file will be used instead!
For setting up a git repository in a multi-repo setup, provide the path to the git repo as an argument to the script:

```sh
./setup-git-repo.sh path-to-repo branch-name
```

`path-to-repo` must be an absolute path.
`branch-name` is optional, default branch is `main`.

Example with real values:

```sh
./setup-git-repo.sh ~/storage/shared/git/notes main
```

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
