# enabling plugins
eval "$(sheldon source)"
eval "$(/opt/homebrew/bin/mise activate zsh)"
eval "$(zoxide init zsh)"

# aliases
alias grep='grep --color=auto'
alias gs='git status'
alias cdi=zi
alias reload='exec zsh' # Replace the shell rather than re-sourcing .zshrc

# standard zsh options
setopt correct
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt inc_append_history
setopt extended_history
setopt notify

HISTSIZE=100000
SAVEHIST=100000

# zsh keeps history/completion state out of $HOME (these dirs must exist first)
mkdir -p "$XDG_STATE_HOME/zsh" "$XDG_CACHE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"

# completion settings: case insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# zsh functions
for file in "$XDG_CONFIG_HOME/zsh/functions/"*(-.N); do
  source "$file"
done

# init completion
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
_comp_options+=(globdots) # Offer dotfiles without typing the leading dot
eval "$(pnpm completion zsh)"

# enable fuzzy finder history
source <(fzf --zsh)

# starship(should be evaluated here)
eval "$(starship init zsh)"
