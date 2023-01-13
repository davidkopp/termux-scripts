# README

This repo includes scripts that are used in Termux on my Android smartphone, e.g. to sync files via Git.

Credits: [Rene Schallner](https://github.com/renerocksai)

Based on his tutorial: [Syncing your Obsidian vault to Android via an encrypted GitHub repository](https://renerocks.ai/blog/obsidian-encrypted-github-android/#shortcuts-for-committing-pushing-and-pulling)

Source of script `git-sync.sh`: [simonthum/git-sync](https://github.com/simonthum/git-sync)

## Setup

Note: The script `setup-git-repo.sh` makes some configurations. If you want other options, modify it before executing it.

1. Clone this repo with Termux
2. Copy `repo.conf` to your home directory and edit it:
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

Note: Creating symlinks in the `.shortcuts` directory that link to scripts outside of the directory are not allowed anymore (see [here](https://github.com/termux/termux-widget/issues/57)).

After that, after exiting Termux, you can open your launcher’s widget menu, select Termux:Widget and place it on your home screen.
You can also use Termux:Tasker to create tasks, e.g. for auto committing and syncing.

## Update script git-sync.sh

```sh
curl https://raw.githubusercontent.com/simonthum/git-sync/master/git-sync -o git-sync.sh
```
