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
gov() { builtin cd "$HOME/govuk/$1"; }
_gov() {
    local cur files
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    files=$(ls $HOME/govuk/)
    COMPREPLY=( $(compgen -W "${files}" -- ${cur}) )
}
complete -F _gov gov
#PROMPT_COMMAND=get_base
alias pd="cd $HOME/govuk/govuk-puppet/development-vm"
alias gu="git checkout master && git pull"

### Added by the Heroku Toolbelt
#export PATH="/usr/local/heroku/bin:$PATH"

function vpn {
    #USKYSCAPE="jabley"
    UGDS="danielroseman"
    case $1 in
        #sky)
            #echo "Connecting to Skyscape VPN"
            #sudo openconnect -b -q --no-cert-check -u $USKYSCAPE --authgroup=CLIENT-VPN1 vpn2.skyscapecloud.com >/dev/null 2>&1
            #;;
        gh)
            echo "Connecting to Github VPN"
            echo "nameserver 192.168.9.1" | sudo tee /etc/resolver/gds >/dev/null
            sudo openconnect -b -q --no-cert-check -u $UGDS --usergroup github vpn.digital.cabinet-office.gov.uk >/dev/null
            ;;
        ah)
            echo "Connecting to Aviation House VPN"
            echo "nameserver 192.168.19.254" | sudo tee /etc/resolver/gds >/dev/null
            sudo openconnect -b -q --no-cert-check -u $UGDS --usergroup ah vpn.digital.cabinet-office.gov.uk >/dev/null
            ;;
        kill)
            echo "Killing openconnect"
            sudo pkill openconnect >/dev/null 2>&1
            echo "nameserver 192.168.19.254" | sudo tee /etc/resolver/gds >/dev/null
            ;;
        status)
            echo "The following openconnect VPNs are connected:"
            ps auxwww | grep openconnec[t] | awk '{print $NF, "is connected"}'
            ;;
        *)
            echo "You need to specify sky/gh/ah/kill/status"
            ;;
    esac
}

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
    /usr/bin/ssh-add ~/.ssh/govuk
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

