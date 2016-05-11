# Execute commands for interactive login and non-login shells as well as
# scripts. This is sourced first.

# Use custom ZDOTDIR inside my dotfiles git repo
export ZDOTDIR="${ZDOTDIR:-$HOME/dotfiles/zsh}"

# Directory for custom functions.
export ZDOTFUNCTIONSDIR="${ZDOTDIR}/functions"

# Directory where I store my custom prompt(s)
export ZPROMPTDIR="${ZDOTDIR}/prompts"

# Directory in which I store git and other repos
export REPODIR="${REPODIR:-$HOME/repos}"

# Directory containing misellaneous scripts and things
# to be sourced that don't have a better home
export SCRIPTDIR="$HOME/scripts"

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

[ -z "$TMUX" ] && export TERM=xterm-256color

# Avoid global compinit in /etc/zsh/zshrc so that we can initialize
# later with a custom location for the dump files.
skip_global_compinit=1

# Treat these characters as part of a word.
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# termcap settings for improved `less` display
export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.

export GREP_COLORS='37;45'

# History vars
export HISTSIZE=10000
export SAVEHIST=9000
export HISTFILE=$HOME/.zsh_history

export SAGEROOT=/opt/sage

# Editors
export EDITOR=/usr/bin/vim
export SUDO_EDITOR=${EDITOR}
export VISUAL=/usr/bin/subl

## Python environment vars

# readline tab-completion
export PYTHONSTARTUP=~/.pythonrc

# I couldn't get vanilla virtualenvwrapper working with pyenv, because
# the pyenv shims always exec the files in 'bin', which doesn't work
# with virtualenvwrapper.sh and virtualenvwrapper_lazy.sh, since they
# are intended to be sourced. Thus, I switched to using the
# pyenv-virtualenv plugin instead of virtualenvwrapper.
export WORKON_HOME="/v"
export PROJECT_HOME="$HOME/repos"

export PYENV_VIRTUALENV_BASE="${WORKON_HOME}"
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_SKIPPIPCHECK="true"
export VIRTUALENVWRAPPER_VIRTUALENV="pyvenv"
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
VIRTUALENVWRAPPER_CONF_DIR="$HOME/.virtualenvs"
#"$(readlink -m -n ${ZDOTDIR}/../virtualenvwrapper)"
# Set path to custom hook scripts for things postactivate events
export VIRTUALENVWRAPPER_HOOK_DIR="$HOME/.virtualenvs"

# remove env var set by ubuntu
unset JAVA_TOOL_OPTIONS
unset GPG_AGENT_INFO

# golang conf
[[ ! -d ~/go ]] && mkdir ~/go
export GOPATH=~/go
path=($path /usr/local/go/bin ${GOPATH}/bin /opt/node/default/bin)

# rust conf
export RUST_SRC_PATH=/usr/local/src/rust/src

# run gpg-agent if not running, or source env file if already running
if test -f $XDG_RUNTIME_DIR/gpg-agent-info && kill -0 $(head -n 1 $XDG_RUNTIME_DIR/gpg-agent-info | cut -d: -f2) 2>/dev/null ; then
    eval $(< $XDG_RUNTIME_DIR/gpg-agent-info)
else
    eval $(gpg-agent --daemon --enable-ssh-support --write-env-file $XDG_RUNTIME_DIR/gpg-agent-info)
fi
export GPG_AGENT_INFO
export SSH_AUTH_SOCK
export GPG_TTY=$(tty)

# add directory for custom functions/completions to fpath
[[ -d "${ZDOTFUNCTIONSDIR}" ]] && fpath=("${ZDOTFUNCTIONSDIR}" $fpath)

# add directory for prompts to fpath
[[ -d "${ZPROMPTDIR}" ]] && fpath=("${ZPROMPTDIR}" $fpath)

# additional path dirs
for dir in  /opt/terraform/default /opt/consul/default /opt/packer/default ${HOME}/bin ${HOME}/.local/bin ${HOME}/.gem/ruby/default/bin /opt/bitkeeper; do
    if [[ -d "${dir}" ]]; then
        path=($path "${dir}")
    fi
done

# additional man dirs
[[ -d "${HOME}/.local/share/man" ]] && export MANPATH=":${HOME}/.local/share/man"

## sublimeconf: filetype=shell
