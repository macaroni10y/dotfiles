#!/usr/bin/env bash
#
# Bootstrap a macOS machine with this dotfiles repo:
#   1. Point zsh at $ZDOTDIR ($HOME/.config/zsh) via /etc/zshenv (needs sudo)
#   2. Install Homebrew if missing
#   3. Install packages from Brewfile
#   4. Symlink every file tracked by this repo into $HOME
#   5. Install dev tool versions pinned in .config/mise/config.toml
#   6. Install Claude Code via the official native installer if missing
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
  local excludes=("README.md" "install.sh" ".gitignore" )
  while IFS= read -r -d '' rel_path; do
    for excl in "${excludes[@]}"; do
      [[ "$rel_path" == "$excl" ]] && continue 2
    done
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

setup_zdotdir() {
  # zsh reads /etc/zshenv before anything in $HOME, so it is the only place that
  # can point zsh at $HOME/.config/zsh instead. Needs sudo; macOS updates may
  # reset the file, in which case re-running this script restores it.
  local system_zshenv="/etc/zshenv"
  if [ -f "$system_zshenv" ] && grep -q 'ZDOTDIR' "$system_zshenv"; then
    log "$system_zshenv already sets ZDOTDIR, skipping"
    return
  fi
  log "Setting ZDOTDIR in $system_zshenv (requires sudo)"
  # shellcheck disable=SC2016  # $HOME must stay literal, zsh expands it at startup
  printf '%s\n' 'export ZDOTDIR="$HOME/.config/zsh"' | sudo tee -a "$system_zshenv" >/dev/null
}

prune_legacy_zsh_links() {
  # Pre-ZDOTDIR layout kept these directly in $HOME. Only remove symlinks that
  # point back into this repo, so hand-written files are never touched.
  local name
  for name in .zshrc .zshenv .zprofile; do
    local link="$HOME/$name"
    if [ -L "$link" ] && [[ "$(readlink "$link")" == "$REPO_DIR/"* ]]; then
      rm "$link"
      log "Removed legacy symlink $link (now lives under \$ZDOTDIR)"
    fi
  done
}

install_claude_code() {
  if command -v claude >/dev/null 2>&1; then
    log "Claude Code already installed, skipping"
    return
  fi
  log "Installing Claude Code (native installer)"
  curl -fsSL https://claude.ai/install.sh | bash
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
  # First: it needs sudo and depends on nothing, so the password prompt happens
  # right away rather than interrupting a long brew bundle. Re-runs skip it.
  setup_zdotdir
  install_homebrew
  install_brew_bundle
  link_dotfiles
  prune_legacy_zsh_links
  install_claude_code
  install_mise_tools
  check_gitconfig_local
  log "Done. Open a new shell or run 'exec zsh'"
}

main "$@"
