export CLICOLOR=1
export PS1="\u@\h:\w\$ "
vima() {
  vim $(git status --porcelain| sed -ne 's/^ M //p')
}
function get_base {
  GOV_BASE=$(pwd|sed -n "s/.*\/govuk\/\([^/]*\).*/\1/p")
}
PROMPT_COMMAND=get_base
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
