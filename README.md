# README

This repo includes scripts that are used in Termux on my Android smartphone.

Credits: [Rene Schallner](https://github.com/renerocksai)

Based on his tutorial: [Syncing your Obsidian vault to Android via an encrypted GitHub repository](https://renerocks.ai/blog/obsidian-encrypted-github-android/#shortcuts-for-committing-pushing-and-pulling)

## Setup

1. Clone this repo with Termux
2. Copy `repo.conf` to your home directory and edit it:
    ```sh
    cp repo.conf $HOME/repo.conf
    nano $HOME/repo.conf
    ```
3. Make the scripts executable:
    ```sh
    chmod +x pull.sh push.sh log.sh setup-shortcuts.sh
    ```
4. Setup shortcuts (relevant for Termux:Widget)
    ```sh
    ./setup-shortcuts.sh
    ```

Note: Creating symlinks in the `.shortcuts` directory that link to scripts outside of the directory are not allowed anymore (see [here](https://github.com/termux/termux-widget/issues/57)).

After that, after exiting termux, you can open your launcher’s widget menu, select Termux:Widget and place it on your home screen.

## Git ignore file mode changes

To avoid conflicts between linux and windows, set git file mode setting to false:

```sh
git config core.fileMode false
```
