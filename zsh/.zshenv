#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#   eukaryote <sapientdust+github@gmail.com>
#

# Use custom ZDOTDIR inside my dotfiles git repo
export ZDOTDIR="${ZDOTDIR:-$HOME/dotfiles/zsh}"

# Directory where I store my custom prompt(s)
export ZPROMPTDIR="${ZDOTDIR}/prompts"

# Directory in which I store git and other repos
export REPODIR="${REPODIR:-$HOME/repos}"

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

[ -z "$TMUX" ] && export TERM=xterm-256color

# History vars
export HISTSIZE=10000
export SAVEHIST=9000
export HISTFILE=~/.zsh_history

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
#
export WORKON_HOME="/v"
export PROJECT_HOME="$HOME/repos"
export PYENV_VIRTUALENV_BASE="${WORKON_HOME}"
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_SKIPPIPCHECK="true"
# pip should use same dir for venvs as virtualenvwrapper
# not needed with pyenv
#export PIP_VIRTUALENV_BASE="${WORKON_HOME}"
# make pip detect an active virtualenv and install to it without -E parameter
# not needed with pyenv
#export PIP_RESPECT_VIRTUALENV="true"
export VIRTUALENVWRAPPER_VIRTUALENV="pyvenv"
# export PREZTO_PYTHON_NO_VIRTUALENVWRAPPER="true"
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"

# remove env var set by ubuntu
unset JAVA_TOOL_OPTIONS
unset GPG_AGENT_INFO

# golang conf
[[ ! -d ~/go ]] && mkdir ~/go
export GOPATH=~/go
path=($path /usr/local/go/bin ${GOPATH}/bin /opt/node/default/bin)

# rust conf
export RUST_SRC_PATH=/usr/local/src/rust/src

# add directory for custom functions/completions to fpath
[[ -d "${ZDOTDIR}/functions" ]] && fpath=("${ZDOTDIR}/functions" $fpath)

# additional path dirs
path=($path /opt/terraform/default /opt/consul/default /opt/packer/default ${HOME}/bin ${HOME}/.local/bin ${HOME}/.gem/ruby/2.1.0/bin)

## sublimeconf: filetype=shell
