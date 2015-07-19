#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   eukaryote <sapientdust+github@gmail.com>
#

# This relies on my a zstyle option I added to my prezto fork to
# avoid doing the virtualenvwrapper initialization that the prezto
# python module performs, which crashes zsh when used in conjunction
# with pyenv. The solution is to use the pyenv-virtualenvwrapper plugin
# for pyenv and ensure that prezto doesn't do the initialization.
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
unsetopt extended_history # don't save timestamp of command and duration
unsetopt inc_append_history # don't add commands incrementally (only at exit)
setopt hist_ignore_dups # don't write adjacent dupes to history
unsetopt hist_ignore_all_dups # don't trim non-adjacent dupes
unsetopt hist_expire_dups_first # don't trim oldest dupes first
setopt hist_ignore_space # ignore history entries that begin with space
unsetopt hist_find_no_dups # let hist-find show dupes (to preserve ordering)
setopt hist_reduce_blanks # remove extra blanks before adding to history
setopt hist_verify # don't execute, just expand history
unsetopt share_history # don't share runtime history across different shells

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
setopt clobber # allow redirecting to existing files without requiring '>>'

# ===== Completion zstyles
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name


# compile a single-file c program
ccompile() {
    local dirpath="$(dirname $1)"
    local filename="$(basename $1)"
    local outname="$(basename ${filename} .c)"

    # echo "dirpath: ${dirpath}"
    # echo "filename: ${filename}"
    # echo "outame: ${outname}"

    if [[ "${outname}" == "${filename}" ]]; then
        echo "usage: ccompile FILE.c"
        return 1
    fi
    (cd "${dirpath}" && gcc -Wall -Wextra -O2 -g -pedantic -std=c11 -o "${outname}" "${filename}")
}

# compile a single-file c program and run the output executable, passing args after
# the first to the executable
crun() {
    filepath="$1"
    ccompile "${filepath}"
    shift
    (cd "$(dirname ${filepath})" && ./$(basename "${filepath}" .c) "$@")
}

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
alias glp="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gs='git status'
alias gd='git diff'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gb='git branch --remotes'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gra='git remote add'
alias grr='git remote rm'
alias grs='git remote show'
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

# history convenience function (zsh requires first=0 below to use full history)
alias history='\history 0'
h() {
    if [[ -n "$1" ]]
    then
        \history 0 | grep -P "$@"
    else
        \history 0
    fi
}

# show environment in sorted order with color-highlight of KEY
# (don't use 'env' as alias, because it interferes with zsh)
alias myenv="env | sort | grep -E '^[A-Z_0-9]+'"
alias envg="env | sort | grep"
alias envgi="env | sort | grep -i"

# page through a single file using less, quitting immediately while leaving
# the `less` output on screen if the file contains no more than one page
# of text, or allowing zsh to restore the original screen state on exit
# if the file contains more than one full page of text.
sless() {
    local page="$(tput lines)"
    local less="$(/bin/which less)"  # avoid aliases/functions

    test "$#" -eq "1" || {
        echo "usage: sless PATH"
        return 1
    }

    if [ "$(head -n $((${page} + 1)) $1 | wc -l)" -le "${page}" ]; then
        # If no more than a page of text, less should quit immediately after
        # showing the output, and '--no-init' needs to be included
        # to prevent zsh from clearing the output on exit and restoring
        # the original screen state, which means the less output disappears.
        LESS="${LESS_SHORT}" ${less} $1
    else
        # If more than a page of text, less should behave as normally under
        # zsh, where we don't prevent init and don't quit if one screen.
        # In this case, zsh will restore the original screen state and not
        # show any of the paged output. Ideally, I'd like to still display
        # only the last page of less output in this case, while still leaving
        # the original terminal contents before invoking less no further than
        # a page away in the terminal, but not investigating for now.
        LESS="${LESS_LONG}" ${less} $1
    fi
}


# Print a spinner at the current cursor location for as long as the process
# with pid equal to the 1st param is running. If no params are passed,
# use the pid of the last background process launched.
spin() {
    local pid="${1:-$!}"
    local period="0.1"
    local spin_chars='|/-\'
    local saved_traps=$(trap)  # current traps, for restoring on completion
    local position=1           # current position within spin_chars

    cleanup() {
        tput cnorm             # show cursor again
        echo -n -e '\b'        # erase last printed spinner char
        eval "${saved_traps}"  # restore original trap state
    }
    tput civis                 # hide cursor while spinning
    trap "cleanup; return 1" INT EXIT  # ensure cleanup occurs

    echo -n " "  # forward 1 char, to prepare for 1st backspace
    while $(kill -0 $pid > /dev/null 2>&1); do
        position=$(($((position+1)) % 4))
        echo -n - "\b${spin_chars:$position:1}"
        sleep $period
    done
    cleanup
}

# launch process disowned and detached from terminal, with stdout and stderr
# both being sent to a file in $TMPDIR/out with name of first param (program).
launch() {
    mkdir -p ${TMPDIR}/out
    # the '&|' is zsh syntax for disowning the job
    "$@" </dev/null >${TMPDIR}/out/$(basename $1) 2>&1 &|
}
# overrides the prezto 'l' alias
alias l=launch

# ls variants
alias ls='ls --group-directories-first --color=auto'
alias la='ls -1A'
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
alias lstr='ls -ltr'
alias lstra='ls -ltrA'

alias manh='man --html'

psg() { ps -ef | grep "$@" | grep -v grep | more; }

# redo last command but pipe it to less
alias redol="!! | less"

# zsh reload commands
alias reload=". ${ZDOTDIR:-$HOME}/.zshrc"
alias reload!="exec zsh"

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
# source $REPODIR/z/z.sh

VIRTUALENVWRAPPER_CONF_DIR="$(readlink -m -n ${ZDOTDIR}/../virtualenvwrapper)"

# Set path to custom hook scripts for things postactivate events
export VIRTUALENVWRAPPER_HOOK_DIR="${VIRTUALENVWRAPPER_CONF_DIR}"

# Don't init the base pyenv here, because prezto already does it
# in the 'python' module.

# Initalize virtualenvwrapper via the pyenv-virtualenvwrapper plugin;
# I had problems getting this to work when pyenv was checked out into
# ~/repos and symlinked to ~/.pyenv, so now pyenv is checked out to
# ~/.pyenv and symlinked to ~/repos/pyenv.
# In order for this to work, the pyenv-virtualenvwrapper plugin needs to
# exist in ~/.pyenv/plugins.
pyenv virtualenvwrapper_lazy

# Initialize my chpwd script that will activate a virtualenv when entering
# a directory that contains a .venv file with the name of a virtualenv inside
# (or entering a descendent of such a directory) and deactivate the virtualenv
# when changing to a directory not inside the virtualenv.
source "${VIRTUALENVWRAPPER_CONF_DIR}/chpwd.zsh"


alias khreload="rm -rf $HOME/.knowhow/data && knowhow load < $HOME/knowhow.dump"
alias khd="knowhow dump"
alias khl="knowhow load < $HOME/knowhow.dump"

# Use pgrep to find the pid of the first arg, and if found, print the
# environment of the process to stdout using the procfs environ file,
# which only reflects the environment when the process was started.
# If called with no args, then print the environment of the current process.
lsenv() { 
    if [[ -n "$1" ]]; then
        pid="$(pgrep $1)"
        if [[ -z "$pid" ]]; then
            echo "no process found: $1"
            return 1
        fi
    else
        pid="self"
    fi
    cat /proc/$pid/environ | tr '\000' '\n'
}

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
    . $HOME/.nix-profile/etc/profile.d/nix.sh;
fi

## sublimeconf: filetype=shell
