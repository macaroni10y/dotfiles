# enabling plugins
eval "$(sheldon source)"
eval "$(/opt/homebrew/bin/mise activate zsh)"
eval "$(zoxide init zsh)"

# aliases
alias grep='grep --color=auto'
alias gs='git status'
alias cdi=zi

# standard zsh options
setopt correct
setopt share_history
setopt hist_ignore_dups hist_ignore_space hist_reduce_blanks
setopt inc_append_history

HISTSIZE=100000
SAVEHIST=100000

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# zsh functions
for file in "$HOME/.config/zsh/functions/"*(.N); do
  source "$file"
done

autoload -Uz compinit && compinit

# starship(should be evaluated here)
eval "$(starship init zsh)"
