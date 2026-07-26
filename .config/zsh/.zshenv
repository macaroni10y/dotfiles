# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Standard PATH additions
export PATH="$HOME/.local/bin:$PATH"

# XDG spec-compliant environment variables

# Android
export ANDROID_USER_HOME="$XDG_DATA_HOME/android"

# AWS CLI
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"

# Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export MISE_CARGO_HOME="$CARGO_HOME"
export MISE_RUSTUP_HOME="$RUSTUP_HOME"

export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export GOPATH="$XDG_DATA_HOME/go"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"

export VIMINIT='set nocompatible | source $XDG_CONFIG_HOME/vim/vimrc'

# Vite+ bin (https://viteplus.dev)
[ -f "$HOME/.vite-plus/env" ] && . "$HOME/.vite-plus/env"
