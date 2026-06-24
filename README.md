# Dotfiles (bare repo)

Portable dev environment. Org-specific config lives in `.local` files (not tracked).

## Setup

```bash
curl -fsSL https://raw.githubusercontent.com/NetanelK/dotfiles/main/bootstrap.sh | bash
```

## Repo Structure

```
~
├── .zshrc                          # Shell config (sources .zshrc.local)
├── .env.zsh                        # Env vars, aliases (sources .env.local)
├── .gitconfig                      # Git settings (includes .gitconfig.local)
├── .Brewfile                       # Homebrew packages
├── .vscode-extensions.txt          # VS Code extension IDs
├── .dotfiles-gitignore             # Bare repo excludes
│
├── .ssh/
│   ├── config                      # SSH settings (includes config.local)
│   └── aws-ssm-ec2-proxy-command.sh
│
├── .claude/
│   ├── CLAUDE.md                   # Claude Code instructions
│   ├── RTK.md                      # RTK reference
│   ├── settings.json.template      # Claude settings (no secrets)
│   ├── statusline-command.sh       # Status bar script
│   ├── hooks/
│   │   ├── rtk-rewrite.sh
│   │   └── sdm-proxy-inject.sh
│   └── rules/
│       └── context7.md
│
├── .config/dotfiles/               # Meta: scripts & templates
│   ├── README.md                   # This file
│   ├── bootstrap.sh                # New machine one-liner
│   ├── macos-defaults.sh           # macOS system prefs
│   └── examples/                   # .local file templates
│       ├── zshrc.local
│       ├── env.local
│       ├── gitconfig.local
│       ├── ssh-config.local
│       ├── aws-config
│       └── saml2aws
│
└── Library/.../Code/User/
    └── settings.json               # VS Code settings
```

## Org-Specific Files (not tracked)

Create from examples: `cp ~/.config/dotfiles/examples/<name> ~/.<target>`

| Example | Target | Purpose |
|---------|--------|---------|
| `zshrc.local` | `~/.zshrc.local` | Org exports (certs, tokens, OTEL) |
| `env.local` | `~/.env.local` | Org aliases |
| `gitconfig.local` | `~/.gitconfig.local` | Org email, autolinks |
| `ssh-config.local` | `~/.ssh/config.local` | Org SSH hosts |
| `aws-config` | `~/.aws/config` | AWS profiles |
| `saml2aws` | `~/.saml2aws` | SAML federation |

## Usage

```bash
dotfiles status
dotfiles add ~/.some-file
dotfiles commit -m "msg"
dotfiles push
```

## Maintenance

```bash
# Update Brewfile
brew bundle dump --global --force && dotfiles add ~/.Brewfile && dotfiles commit -m "update Brewfile" && dotfiles push

# Update VS Code extensions
code --list-extensions | sort > ~/.vscode-extensions.txt && dotfiles add ~/.vscode-extensions.txt && dotfiles commit -m "update exts" && dotfiles push
```
