#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   eukaryote <sapientdust+github@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

function ddu () {
    (cd ${1:-.} && du -hs * | sort -h)
}

unsetopt correct_all

# -------------------------------------------------------------------
# Git
# -------------------------------------------------------------------
alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gpl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gs='git status'
alias gd='git diff'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gra='git remote add'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'
alias gta='git tag -a -m'
alias gf='git reflog'
alias gv='git log --pretty=format:'%s' | cut -d " " -f 1 | sort | uniq -c | sort -nr'

# leverage aliases from ~/.gitconfig
alias gh='git hist'
alias gt='git today'

# curiosities
# gsh shows the number of commits for the current repos for all developers
alias gsh="git shortlog | grep -E '^[ ]+\w+' | wc -l"

# gu shows a list of all developers and the number of commits they've made
alias gu="git shortlog | grep -E '^[^ ]'"


alias env="\env | \sort | grep -P '^[A-Z_0-9]+'"
alias envg="\env | \sort | grep"
alias envgi="\env | \sort | grep"

function psgi() { ps -ef | grep -i "$@" | grep -v grep | more; }
function psg() { ps -ef | grep "$@" | grep -v grep | more; }

alias redol="!! | less"

# Print the IP address of the first interface that has a non-localhost IP
# adress, returning 0 if successful and 1 if not.
function thisip() {
  ip_pat="addr:([0-9]+\.){3}[0-9]+"
  for ip in $(/sbin/ifconfig -a | egrep -E -o $ip_pat | cut -d: -f2); do
    if [ "127." != $(expr substr $ip 1 4) ]; then
      echo $ip;
      return 0;
    fi
  done
  return 1;
}

function hostinfo() {
  ip=$(this_ip)
  echo -e "\nLogged in to ${RED}$HOSTNAME${NCOL} (${ip:-\"Not connected\"})"
  echo -e "\n${RED}Additional information:${NCOL} " ; uname -a
  echo -e "\n${RED}Users logged on:${NCOL} " ; w -h
  echo -e "\n${RED}Current date:${NCOL} " ; date
  echo -e "\n${RED}Machine stats:${NCOL} " ; uptime
  echo -e "\n${RED}Memory stats:${NCOL} " ; free
}

remind() {
    if ! test -x $(which zenity 2> /dev/null)
    then
        echo "zenity is not on PATH or not not executable"
        return 1
    fi
    if [ $# -lt 2 ]
    then
        echo "Usage: ./remind.sh <seconds> \"Remind Message...\""
        return 1
    fi
    seconds=$1
    shift
    # run in background as a subprocess so we can redirect to /dev/null
    # and not show the PID of the process that is still running
    ({
        sleep ${seconds} </dev/null &>/dev/null &&
        zenity --info --title="Remind" --text="$*" </dev/null &>/dev/null
    } &) > /dev/null
    echo "$(date):  Reminder set for ${seconds} seconds"
}

## sublimeconf: filetype=shell
