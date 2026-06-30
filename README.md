# dotfiles

My personal dotfiles for macOS and zsh.

## Structure

### XDG-ish style

Almost all files are under `~/.config` except for the shell config files, several config files already existing in `$HOME`(which aren't tracked by git), and the `Brewfile` and `install.sh` script.

### Auth isolation

Nothing account-specific is committed. These files are created per machine and excluded via `.gitignore`.

- `~/.config/git/config.local`: your `[user]` block (name and email). The shared git config pulls it in with `[include]`
- `~/.config/gh/hosts.yml`: the token written by `gh auth login`

HTTPS git auth goes through `gh auth git-credential`, so there's nothing else to configure.

## Requirements
- macOS (Apple Silicon only)
- zsh

## Installation

```sh
./install.sh
```

The script does the following:

1. Install Homebrew if it's not already there
2. Run `brew bundle` to install packages, casks, and VS Code extensions from `Brewfile`
3. Symlink every file tracked by this repo into `$HOME` (existing files get moved to `~/.dotfiles_backup/` first)
4. Run `mise install` to pull in the tool versions pinned in `.config/mise/config.toml`
5. Remind you to create `~/.config/git/config.local` if it's missing
