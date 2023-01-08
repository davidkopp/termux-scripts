# README

This repo includes scripts that are used in Termux on my Android smartphone, e.g. to sync files via Git.

Credits: [Rene Schallner](https://github.com/renerocksai)

Based on his tutorial: [Syncing your Obsidian vault to Android via an encrypted GitHub repository](https://renerocks.ai/blog/obsidian-encrypted-github-android/#shortcuts-for-committing-pushing-and-pulling)

Source of script `git-sync.sh`: [simonthum/git-sync](https://github.com/simonthum/git-sync)

## Setup

1. Clone this repo with Termux
2. Copy `repo.conf` to your home directory and edit it:
    ```sh
    cp repo.conf $HOME/repo.conf
    nano $HOME/repo.conf
    ```
3. Make the setup script executable:
    ```sh
    chmod +x setup-scripts.sh
    ```
4. Run setup script
    ```sh
    ./setup-scripts.sh
    ```

Note: Creating symlinks in the `.shortcuts` directory that link to scripts outside of the directory are not allowed anymore (see [here](https://github.com/termux/termux-widget/issues/57)).

After that, after exiting Termux, you can open your launcher’s widget menu, select Termux:Widget and place it on your home screen.
You can also use Termux:Tasker to create tasks, e.g. for auto committing and syncing.

## Git ignore file mode changes

To avoid conflicts between Linux and Windows, set git file mode setting to false:

```sh
git config core.fileMode false
```

## Update script git-sync.sh

```sh
curl https://raw.githubusercontent.com/simonthum/git-sync/master/git-sync -o git-sync.sh
sed -i 's/^DEFAULT_AUTOCOMMIT_MSG.*$/DEFAULT_AUTOCOMMIT_MSG=\"android on $(printf \x27%(%Y-%m-%d %H:%M:%S)T\\n\x27 -1)\"/' git-sync.sh
```
