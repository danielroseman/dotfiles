export CLICOLOR=1
export PS1="\u@\h:\w\$ "
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

vima() {
  vim $(git status --porcelain| sed -ne 's/^ M //p')
}
function get_base {
  GOV_BASE=$(pwd|sed -n "s/.*\/govuk\/\([^/]*\).*/\1/p")
}
gc() { builtin cd "$HOME/gc/$1"; }
alias gcp="cd ~/gc/payments-service"
alias gcbi="cd ~/gc/payments-service/plugins/banking_integrations"
_gc() {
    local cur files
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    files=$(ls $HOME/gc/)
    COMPREPLY=( $(compgen -W "${files}" -- ${cur}) )
}
complete -F _gc gc
#PROMPT_COMMAND=get_base

alias gu="git checkout master && git pull"
alias rc="bundle exec rails c"
alias brc="bundle && bundle exec rails c"
alias diffocop="git diff origin/master --name-only --diff-filter=ACMRTUXB | grep '\.rb$' | tr '\n' ' ' | xargs bundle exec rubocop"
newdraupnir() {
  eval $(draupnir new)
  export PGDATABASE=gc_paysvc_live
  bidraupnir
}
setdraupnir() {
  eval $(draupnir env $1)
  bidraupnir
  export PGDATABASE=gc_paysvc_live
}
bidraupnir() {
  for i in PGHOST PGPORT PGUSER PGPASSWORD; do
    export BANKING_INTEGRATIONS_$i=${!i};
  done
  export BANKING_INTEGRATIONS_PGDATABASE=gc_banking_integrations_live
}
undraupnir() {
  for i in PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE; do
    unset $i BANKING_INTEGRATIONS_$i;
  done
}
showdraupnir() {
  for i in PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE; do
    echo "$i: ${!i}"
  done
  for i in PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE; do
    ii=BANKING_INTEGRATIONS_$i
    echo "BANKING_INTEGRATIONS_$i: ${!ii}"
  done
}

alias listdraupnir="draupnir instances list"

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

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
