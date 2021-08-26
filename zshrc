setopt CORRECT
setopt CORRECT_ALL
setopt AUTO_CD
export CLICOLOR=1
export EDITOR=vim

PROMPT='%~ %# '

autoload -Uz vcs_info
precmd_functions+=( vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{240}%b%f'
zstyle ':vcs_info:*' enable git

autoload -Uz compinit && compinit
gc() {
  builtin cd "$HOME/gc/$1";
  echo -ne "\033]0;$1\007";
}
alias gcp="gc payments-service"

_gc() {
  _path_files -/ -W ~/gc
}
compdef _gc gc

WORDCHARS="${WORDCHARS//[-\/]/}"

alias gu="git checkout master && git pull"
alias gp="git pull"
alias gb='branch=$(git for-each-ref --format "%(refname:lstrip=2)" --sort="-authordate" refs/heads | fzf) && git checkout $branch'
alias rc="bundle exec rails c"
alias brc="bundle && bundle exec rails c"
alias rspec="nocorrect bundle exec rspec"
alias diffocop="git diff origin/master --name-only --diff-filter=ACMRTUXB | grep '\.rb$' | tr '\n' ' ' | xargs bundle exec rubocop"

draupnirdb() {
  case ${PWD##*/} in
    frontier) export PGDATABASE=gc_banking_integrations_live;;
    payments-service) export PGDATABASE=gc_paysvc_live;;
  esac
}
newdraupnir() {
  eval $(draupnir new)
  draupnirdb
}
setdraupnir() {
  eval $(draupnir env $1)
  draupnirdb
}
undraupnir() {
  for i in PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE PGSSLROOTCERT PGSSLMODE PGSSLCERT PGSSLKEY; do
    unset $i;
  done
}
showdraupnir() {
  for i in PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE; do
    echo "$i: ${(P)i}"
  done
}
getdraupnir() {
  INSTANCE=`draupnir instances list | cut -d ' ' -f1`
  eval $(draupnir env $INSTANCE)
  draupnirdb
}

setdrc() {
  eval $(draupnir env $1)
  draupnirdb
  rc
}

alias listdraupnir="draupnir instances list"
alias newdrc="newdraupnir && rc"
alias getdrc="getdraupnir && rc"

# Gcloud
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
export PROJECT_HOME=/Users/danielroseman/Projects

eval "$(rbenv init -)"

SSH_ENV="$HOME/.ssh/environment"

if [ -f ~/.tokens ]; then
  . ~/.tokens
fi

# Spring is more trouble than it's worth
export DISABLE_SPRING=1

export BAT_THEME="Solarized (dark)"

export FZF_DEFAULT_COMMAND='fd --type f'
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# toggle bluetooth
alias bt='blueutil -p $((1-$(blueutil -p)))'

alias sftp='with-readline sftp'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


export PATH="$HOME/.poetry/bin:$PATH"
