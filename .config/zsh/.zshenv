# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Standard PATH additions
export PATH="$HOME/.local/bin:$PATH"

# --- XDG compliance for tools that only honour env vars ---
# Verified against `xdg-ninja`. Each entry keeps a dotfile out of $HOME.

# Android: emulator images and adb keys. Android Studio honours this too.
export ANDROID_USER_HOME="$XDG_DATA_HOME/android"

# AWS CLI: note that ~/.aws/sso and ~/.aws/cli are hardcoded upstream and stay.
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"

# Rust: mise's core:rust backend wraps rustup, so its installs symlink into
# $CARGO_HOME/bin. Changing these requires `mise install rust --force` to
# repoint that symlink.
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
# `mise activate` (run from .zshrc, i.e. after this file) re-exports
# CARGO_HOME/RUSTUP_HOME with its own hardcoded ~/.cargo and ~/.rustup, silently
# clobbering the two lines above. The MISE_* vars are what that backend actually
# reads -- they are undocumented and rejected by `mise settings set`, but honoured.
export MISE_CARGO_HOME="$CARGO_HOME"
export MISE_RUSTUP_HOME="$RUSTUP_HOME"

export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export GOPATH="$XDG_DATA_HOME/go"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

# npm: only the user config is relocated here; `cache` is set inside that npmrc.
# `prefix` is deliberately left alone -- mise owns it (node install dir).
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# vim: no vimrc of our own, so point VIMINIT at the XDG one that sets viminfofile.
export VIMINIT='set nocompatible | source $XDG_CONFIG_HOME/vim/vimrc'

# Vite+ bin (https://viteplus.dev)
[ -f "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"
