export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"

# Homebrew completions (must be before compinit/oh-my-zsh)
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Completions
autoload -Uz compinit
compinit

plugins=(fzf-tab aliases ansible aws brew docker git git-auto-fetch gh python colorize colored-man-pages fzf kubectl helm pre-commit thefuck terragrunt zsh-syntax-highlighting zsh-autosuggestions eks-ssm)

source $ZSH/oh-my-zsh.sh
source ~/.env.zsh

zstyle ':completion::*:ls::*' fzf-completion-opts --preview='eval head {1}'

# Kubeswitch
source <(switcher init zsh)
alias s=switch
source <(compdef _switcher switch)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terragrunt terragrunt
eval "$(zoxide init zsh)"
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"
export PATH="/opt/homebrew/opt/bison/bin:$PATH"
export PATH="/opt/homebrew/opt/expat/bin:$PATH"

# Org-specific / local overrides (not tracked)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Claude Code telemetry — managed by Intune
export CLAUDE_CODE_ENABLE_TELEMETRY="1"
export OTEL_METRICS_EXPORTER="otlp"
export OTEL_LOGS_EXPORTER="otlp"
export OTEL_EXPORTER_OTLP_PROTOCOL="http/protobuf"
export OTEL_EXPORTER_OTLP_ENDPOINT="http://127.0.0.1:10198"
export OTEL_EXPORTER_OTLP_HEADERS=""
export OTEL_LOG_TOOL_DETAILS="1"
export OTEL_RESOURCE_ATTRIBUTES="user.login=$(whoami),user.email=$(whoami)@kaltura.com"
