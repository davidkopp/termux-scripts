# README

This repo includes scripts that are used in [Termux](https://termux.dev/) on my Android devices. Termux is an Android terminal emulator and Linux environment app.

The main purpose is to sync my [Obsidian](https://obsidian.md/) vault between devices via Git.

The idea to use Termux for automatic syncing came from [Rene Schallner](https://github.com/renerocksai): [Syncing your Obsidian vault to Android via an encrypted GitHub repository](https://renerocks.ai/blog/obsidian-encrypted-github-android/#shortcuts-for-committing-pushing-and-pulling)

For syncing I'm now using the script `git-sync.sh` by Simon Thum: [simonthum/git-sync](https://github.com/simonthum/git-sync)

## Setup

_Note: The script `setup-git-repo.sh` makes some configurations. If you want other options, modify it before executing it._

1. Clone this repo with Termux to your Android device
2. Copy `repo.conf` to your home directory and edit it to your personal needs:
    ```sh
    cp repo.conf $HOME/repo.conf
    nano $HOME/repo.conf
    ```
3. Make the setup scripts executable:
    ```sh
    chmod +x setup-scripts.sh
    chmod +x setup-git-repo.sh
    ```
4. Run setup scripts
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
