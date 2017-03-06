## sublimeconf: filetype=shell

setopt CORRECT

# disable correction
alias cd='nocorrect cd'
alias cp='nocorrect cp'
alias gcc='nocorrect gcc'
alias grep='nocorrect grep'
alias ln='nocorrect ln'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias rm='nocorrect rm'

# disable globbing
alias history='noglob history'
alias find='noglob find'
alias locale='noglob locale'
alias scp='noglob scp'

alias e='${(z)VISUAL:-${(z)EDITOR}}'
alias type='type -a'

alias c='curly'

alias ls='ls --group-directories-first'
if [[ -s "$HOME/.dir_colors" ]]; then
    eval "$(dircolors --sh "$HOME/.dir_colors")"
else
    eval "$(dircolors --sh)"
fi
alias ls="${aliases[ls]:-ls} --color=auto"
alias l='ls -1A'         # Lists in one column, hidden files.
alias ll='ls -lh'        # Lists human readable sizes.
alias lr='ll -R'         # Lists human readable sizes, recursively.
alias la='ll -A'         # Lists human readable sizes, hidden files.
alias lm='la | "$PAGER"' # Lists human readable sizes, hidden files through pager.
alias lx='ll -XB'        # Lists sorted by extension (GNU only).
alias lk='ll -Sr'        # Lists sorted by size, largest last.
alias lt='ll -tr'        # Lists sorted by date, most recent last.
alias lc='lt -c'         # Lists sorted by date, most recent last, shows change time.
alias lu='lt -u'         # Lists sorted by date, most recent last, shows access time.
alias grep="${aliases[grep]:-grep} --color=auto"

alias clipc='xclip -selection clipboard'
alias clipp='xclip -selection clipboard -o'

alias df='df -kh'
alias du='du -kh'
ddu () {
    # show human-readable listing of sub-directory sizes in descending order
    # of size, using $1 as the directory or defaulting to '.' if none given
    cd ${1:-.} && du -hs * | sort -h
}

alias grep='grep --color=AUTO'

alias gpg=gpg2

# history convenience function (zsh requires first=0 below to use full history)
alias history='noglob history 0'

# show environment in sorted order with color-highlight of KEY
# (don't use 'env' as alias, because it interferes with zsh)
alias myenv="env | sort | grep -E '^[A-Z_0-9]+'"
alias envg="env | sort | grep"
alias envgi="env | sort | grep -i"

# make directory and cd into it
function mkcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

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

alias lua='lua5.3'
alias luac='luac5.3'

# redo last command but pipe it to less
alias redol="!! | less"

# zsh reload commands
alias reload=". ${ZDOTDIR:-$HOME}/.zshrc"
alias reload!="exec zsh"

# undo the annoying aliasing of rm as 'rm -i' that prezto sets up
alias rm="nocorrect rm"

# ensure TERM set correctly so we can get 24-bit colors in tmux 2.2+
alias tmux="env TERM=xterm-256color tmux"

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
