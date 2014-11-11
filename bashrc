export CLICOLOR=1
export PS1="\u@\h:\w\$ "
vima() {
  vim $(git status --porcelain| sed -ne 's/^ M //p')
}
function get_base {
  GOV_BASE=$(pwd|sed -n "s/.*\/govuk\/\([^/]*\).*/\1/p")
}
gov() { builtin cd "$HOME/govuk/$1"; }
_gov() {
    local cur files
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    files=$(ls $HOME/govuk/)
    COMPREPLY=( $(compgen -W "${files}" -- ${cur}) )
}
complete -F _gov gov
PROMPT_COMMAND=get_base
alias pd="cd $HOME/govuk/puppet/development"
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
