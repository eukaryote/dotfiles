#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   eukaryote <sapientdust+github@gmail.com>
#

zstyle ':prezto:module:python' skip-virtualenvwrapper-init yes

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Settings below adapted from
# http://zanshin.net/2013/02/02/zsh-configuration-from-the-ground-up/

# ===== Basics
setopt no_beep # don't beep on error
setopt interactive_comments # Allow comments even in interactive shells

# ===== Changing Directories
unsetopt auto_cd # disable `foo` as abbr for `cd foo` when 'foo' is in cdpath
setopt cdablevarS # can cd to $foo using `cd foo` if $foo is a valid directory
unsetopt pushd_ignore_dups # allow pushd dups

# ===== Expansion and Globbing
setopt extended_glob # treat #, ~, ^ as part of pattern for filename generation

# ===== History
setopt append_history # multiple terminal sessions all append to same history
unsetopt extended_history # save timestamp of command and duration
setopt inc_append_history # add comamnds as they are typed, not at shell exit
setopt hist_expire_dups_first # trim oldest dupes first
unsetopt hist_ignore_dups # do write dupe events to history
setopt hist_ignore_space # ignore history entries that begin with space
setopt hist_find_no_dups # don't display search results already cycled twice
setopt hist_reduce_blanks # remove extra blanks before adding to history
setopt hist_verify # don't execute, just expand history
setopt share_history # imports new commands & appends typed commands to history

# ===== Completion
setopt always_to_end # move cursor to end of word when completing from middle
unsetopt auto_menu # don't show completion menu
unsetopt auto_name_dirs # disable auto var generation of dirs
setopt complete_in_word # allow completion from within a word/phrase
unsetopt complete_aliases # alias expansion before completion finishes is okay

unsetopt menu_complete # do not autoselect the first completion entry

# ===== Correction
unsetopt correct # spelling correction for commands
unsetopt correctall # no spelling correction for arguments

# ===== Prompt
setopt prompt_subst # enable all prompt expansion and substitution
unsetopt transient_rprompt # don't restrict rprompt to the current prompt

# ===== IO
setopt multios # implicit tees or cats when multiple redirections attempted
setopt clobber # allow redirecting to existing files without requiring >>

# show human-readable listing of sub-directory sizes in descending order
# of size, using $1 as the directory or defaulting to '.' if none given
ddu () {
    cd ${1:-.} && du -hs * | sort -h
}

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

# history utilities
h() {
    if [[ -n "$1" ]]
    then
        history | grep -E "$1"
    else
        history
    fi
}

# show environment in sorted order with color-highlight of KEY
# (don't use 'env' as alias, because it interferes with z.sh)
alias myenv="env | sort | grep -E '^[A-Z_0-9]+'"
alias envg="env | sort | grep"
alias envgi="env | sort | grep -i"

# ls variants
alias ll='ls -lh'
alias lla='ll -a'
alias lls='ll -s'
alias llsa='lls -A'
alias llsr='lls -r'
alias llsra='llsr -A'
alias llt='ll -t'
alias llta='llt -A'
alias lltr='llt -r'
alias lltra='lltr -A'

psg() { ps -ef | grep "$@" | grep -v grep | more; }
psgi() { ps -ef | grep -i "$@" | grep -v grep | more; }

# redo last command but pipe it to less
alias redol="!! | less"

# undo the annoying aliasing of rm as 'rm -i' that prezto sets up
alias rm="nocorrect rm"


# if zenity is intalled, then popup a reminder after $1 seconds;
# e.g., `remind 160 tea is ready`
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

# initialize z.sh (https://github.com/rupa/z)
source $REPODIR/z/z.sh

# initialize virtualenvwrapper, which is on PATH somewhere
# source $(which virtualenvwrapper.sh)
eval "$(pyenv init -)"

# initalize virtualenvwrapper via the pyenv-virtualenvwrapper plugin
pyenv virtualenvwrapper_lazy

## sublimeconf: filetype=shell
