#!/bin/zsh

# Environment Config
export EDITOR=vim
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export NVM_DIR="$HOME/.nvm"
export GOPATH="$HOME/go"
export PATH=$PATH:$(go env GOPATH)/bin

# NVM config
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Generic aliases
alias ghbc='gh browse --branch $(git_current_branch)'
alias ghprcw="gh pr create --web"
alias myip="curl http://ipecho.net/plain; echo"
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias kdebug="kubectl debug --image nicolaka/netshoot --stdin --tty --profile=netadmin"
alias gcleanup="git branch -vv --format '%(refname:strip=2) %(upstream:track)' | awk '/gone]/{print \$1}' | xargs -n1 git branch -D"
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# FZF config
zstyle ':fzf-tab:complete:(ls|cat|cd|vim|less):*' fzf-preview 'less ${(Q)realpath}'
zstyle ':fzf-tab:complete:(ls|cat|cd|vim|less):options' fzf-preview
zstyle ':fzf-tab:complete:(ls|cat|cd|vim|less):argument-1' fzf-preview
zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview 'brew info $word'
zstyle ':fzf-tab:complete:docker-(run|push|images):argument-rest' fzf-preview 'docker inspect $word'
zstyle ':fzf-tab:complete:*:options' fzf-preview
export LESSOPEN='|~/.lessfilter %s'

# Org-specific overrides (not tracked)
[ -f ~/.env.local ] && source ~/.env.local
