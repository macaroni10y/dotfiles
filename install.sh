#!/usr/bin/env bash
#
# Bootstrap a macOS machine with this dotfiles repo:
#   1. Install Homebrew if missing
#   2. Install packages from Brewfile
#   3. Symlink every file tracked by this repo into $HOME
#   4. Install dev tool versions pinned in .config/mise/config.toml
#
# Usage: ./install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d%H%M%S)"

log() { printf '\033[1;32m==>\033[0m %s\n' "$1"; }

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi
  log "Homebrew not found, installing it"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

install_brew_bundle() {
  log "Installing packages from Brewfile"
  brew bundle --file="$REPO_DIR/Brewfile"
}

link_dotfiles() {
  log "Symlinking dotfiles into \$HOME"
  while IFS= read -r -d '' rel_path; do
    src="$REPO_DIR/$rel_path"
    dest="$HOME/$rel_path"

    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ]; then
      [ "$(readlink "$dest")" = "$src" ] && continue
      rm "$dest"
    elif [ -e "$dest" ]; then
      mkdir -p "$(dirname "$BACKUP_DIR/$rel_path")"
      mv "$dest" "$BACKUP_DIR/$rel_path"
      log "Backed up existing $dest to $BACKUP_DIR/$rel_path"
    fi

    ln -s "$src" "$dest"
  done < <(git -C "$REPO_DIR" ls-files -z)
}

install_mise_tools() {
  if command -v mise >/dev/null 2>&1; then
    log "Installing tools with mise"
    (cd "$REPO_DIR" && mise install)
  fi
}

check_gitconfig_local() {
  local gitconfig_local="$HOME/.config/git/config.local"
  if [ ! -e "$gitconfig_local" ]; then
    log "NOTE: $gitconfig_local not found"
    cat <<EOF
  This machine has no git identity yet. Create $gitconfig_local with:

    [user]
        name = Your Name
        email = your@email.example

EOF
  else
    log "$gitconfig_local already exists, it will be used as-is"
  fi
}

main() {
  install_homebrew
  install_brew_bundle
  link_dotfiles
  install_mise_tools
  check_gitconfig_local
  log "Done. Open a new shell or run 'exec zsh'"
}

main "$@"
