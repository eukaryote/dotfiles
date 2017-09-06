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
export VISUAL=${EDITOR}

## Python environment vars

# readline tab-completion
export PYTHONSTARTUP=~/.pythonrc

# start with no PYTHONPATH
unset PYTHONPATH

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
#unset GPG_AGENT_INFO

# golang conf
[[ ! -d ~/go ]] && mkdir ~/go
export GOPATH=$HOME/go
export GOROOT=/opt/go/default

# directories to be prepended to head of path
# in array-order (prepended in order defined);
# $HOME/bin should be last, as it the pyenv
# shims will be inserted after the first element
# so that executables in $HOME/bin are found first.
extra_path_dirs=(
    /opt/git/default/bin
    /opt/curl/default/bin
    /opt/nghttp2/default/bin
    /opt/zookeeper/default/bin
    /opt/kafkacat/default/bin
    /opt/terraform/default
    /opt/packer/default
    /opt/consul/default
    /opt/go/default/bin
    /opt/node/default/bin
    /opt/nim/default/bin
    $HOME/.gem/ruby/default/bin
    ${GOPATH}/bin
    $HOME/.cabal/bin
    $HOME/.cargo/bin
    $HOME/.nimble/bin
    $HOME/.local/bin
    $HOME/bin
)
for dir in  "${extra_path_dirs[@]}"
do
    if [[ -d "${dir}" ]]
    then
        path=("${dir}" ${path[@]})
    fi
done

# directories to be prepended to head of LD_LIBRARY_PATH
# if they exist.
extra_library_dirs=(
    #/usr/local/lib
)
if [[ -n "${extra_library_dirs}" ]]
then
    for dir in "${extra_library_dirs[@]}"
    do
       if [[ -d "${dir}" ]]
        then
            LD_LIBRARY_PATH="${dir}:${LD_LIBRARY_PATH}"
        fi
    done
    export LD_LIBRARY_PATH="${LD_LIBRARY_PATH%%:}"
fi

# Log TLS keys to file for wireshark debugging
export SSLKEYLOGFILE="${HOME}/.ssl/sslkeylogfile.txt"
[[ -f "${SSLKEYLOGFILE}" ]] || ( mkdir -m 02700 -p "$(dirname "${SSLKEYLOGFILE}")" && umask 077 && touch "${SSLKEYLOGFILE}" )
# Only enable as needed by commenting out the next line:
unset SSLKEYLOGFILE

# rust conf
export RUST_SRC_PATH=/usr/local/src/rust/src

# gpg-agent autostarts since 2.1; write-env-file is no longer needed or supported
export GPG_TTY=$(tty)

# helper to add an fpath entry if it's a dir and not already in fpath
addfpath() {
    # don't need to check if it's in the array already, because fpath
    # is declared with '-U' so won't add it if already present
    [[ -d "$1" ]] && fpath=("$1" ${fpath})
}

# add standard zsh completions to fpath
addfpath "/usr/share/zsh/vendor-completions"

# add custom functions/completions to fpath
addfpath "${ZDOTFUNCTIONSDIR}"

# add directory for prompts to fpath
addfpath "${ZPROMPTDIR}"

test -f "${HOME}/.zshenv-custom" && source "${HOME}/.zshenv-custom"

# additional man dirs
[[ -d "${HOME}/.local/share/man" ]] && export MANPATH=":${HOME}/.local/share/man"
[[ -d "${HOME}/share/man" ]] && export MANPATH="${HOME}/share/man:${MANPATH}"
[[ -d "/opt/zsh/default/share/man" ]] && export MANPATH="/opt/zsh/default/share/man:${MANPATH}"

## sublimeconf: filetype=shell
