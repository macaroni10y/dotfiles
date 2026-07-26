# dotfiles

My personal dotfiles for macOS and zsh.

## Structure

### XDG style

Everything tracked here lives under `~/.config`, including the zsh config files
(`Brewfile` and `install.sh` stay at the repo root and are never symlinked).

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

1. Set `ZDOTDIR` in `/etc/zshenv` — asks for sudo first thing, so the prompt
   doesn't interrupt the long `brew bundle` below (skipped if already set)
2. Install Homebrew if it's not already there
3. Run `brew bundle` to install packages, casks, and VS Code extensions from `Brewfile`
4. Symlink every file tracked by this repo into `$HOME` (existing files get moved to `~/.dotfiles_backup/` first), then drop the pre-`ZDOTDIR` symlinks
5. Run `mise install` to pull in the tool versions pinned in `.config/mise/config.toml`
6. Remind you to create `~/.config/git/config.local` if it's missing

Run it from a real terminal: `sudo` reads the password from the terminal device,
so piping the script through something without a TTY makes step 1 fail.
