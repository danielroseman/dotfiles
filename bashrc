export CLICOLOR=1
export PS1="\u@\h:\w\$ "
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

export EDITOR=vim

vima() {
  vim $(git status --porcelain| sed -ne 's/^ M //p')
}
function get_base {
  GOV_BASE=$(pwd|sed -n "s/.*\/govuk\/\([^/]*\).*/\1/p")
}
gc() {
  builtin cd "$HOME/gc/$1";
  echo -ne "\033]0;$1\007";
}
alias gcp="gc payments-service"

_gc() {
    local cur files
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    files=$(ls $HOME/gc/)
    COMPREPLY=( $(compgen -W "${files}" -- ${cur}) )
}
complete -F _gc gc


alias gu="git checkout master && git pull"
alias gp="git pull"
alias rc="bundle exec rails c"
alias brc="bundle && bundle exec rails c"
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
    echo "$i: ${!i}"
  done
}

alias listdraupnir="draupnir instances list"
alias newdrc="newdraupnir && rc"

export NVM_DIR=~/.nvm
source /usr/local/opt/nvm/nvm.sh

### Added by the Heroku Toolbelt
#export PATH="/usr/local/heroku/bin:$PATH"


VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
export PROJECT_HOME=/Users/danielroseman/Projects

eval "$(rbenv init -)"

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

#if [ -f "${SSH_ENV}" ]; then
    #. "${SSH_ENV}" > /dev/null
    ##ps ${SSH_AGENT_PID} doesn't work under cywgin
    #ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        #start_agent;
    #}
#else
    #start_agent;
#fi

if [ -f ~/.tokens ]; then
  . ~/.tokens
fi

# Spring is more trouble than it's worth
export DISABLE_SPRING=1

export BAT_THEME="Solarized (dark)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# toggle bluetooth
alias bt='blueutil -p $((1-$(blueutil -p)))'

alias sftp='with-readline sftp'
