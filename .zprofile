# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Standard PATH additions
export PATH="$HOME/.local/bin:$PATH"

# Homebrew environment
eval "$(/opt/homebrew/bin/brew shellenv)"
