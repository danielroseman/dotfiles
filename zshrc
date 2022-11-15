setopt CORRECT
setopt CORRECT_ALL
setopt AUTO_CD
export CLICOLOR=1
export EDITOR=nvim

PROMPT='%~ %# '

autoload -Uz vcs_info
precmd_functions+=( vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{240}%b%f'
zstyle ':vcs_info:*' enable git

autoload -Uz compinit && compinit
alias dcd="dev cd"
alias dvt="dev vault tls production shopify certify/elasticsearch/client/intermediate/v2 es-client --cn arrive-server-production-unrestricted && dev vault tls production shopify certify/elasticsearch/client/intermediate/v2 es-client --cn shop-discovery-pipeline-staging-unrestricted"
alias disco="nocorrect disco"

autoload -U select-word-style
select-word-style bash
bindkey -e

function default_branch() { git symbolic-ref --short refs/remotes/origin/HEAD| sed 's@^origin/@@'  }
alias gu='git checkout $(git symbolic-ref --short refs/remotes/origin/HEAD| sed "s@^origin/@@") && git pull'
alias gp="git pull"
alias gb='branch=$(git for-each-ref --format "%(refname:lstrip=2)" --sort="-authordate" refs/heads | fzf) && git checkout $branch'
alias gcf='git commit --fixup "$(git log --oneline | fzf --no-sort | awk "{print \$1}")"'
alias rc="bundle exec rails c"
alias brc="bundle && bundle exec rails c"
alias rspec="nocorrect bundle exec rspec"
alias diffocop="git diff origin/master --name-only --diff-filter=ACMRTUXB | grep '\.rb$' | tr '\n' ' ' | xargs bundle exec rubocop"

export PROJECT_HOME=/Users/danielroseman/Projects

# eval "$(rbenv init -)"

SSH_ENV="$HOME/.ssh/environment"

if [ -f ~/.tokens ]; then
  . ~/.tokens
fi

if [ "$SPIN" ]; then
  alias ls='ls --color'
  alias bat="batcat"
  PROMPT='%m:%~ %# '
fi

# Spring is more trouble than it's worth
export DISABLE_SPRING=1

export BAT_THEME="gruvbox-dark"

export FZF_DEFAULT_OPTS="--color='fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f,info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:5:hidden:wrap --bind 'ctrl-h:toggle-preview'"
export FZF_DEFAULT_COMMAND='fd --type f'
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# toggle bluetooth
alias bt='blueutil -p $((1-$(blueutil -p)))'

alias sftp='with-readline sftp'

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


export PATH="$HOME/.poetry/bin:$PATH"

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh
if [ -e /Users/danielroseman/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/danielroseman/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)
