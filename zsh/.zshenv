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

export PATH=$HOME/bin/:/opt/python/default/bin:${PATH}

# History vars
export HISTSIZE=10000
export SAVEHIST=9000
export HISTFILE=~/.zsh_history


## Python environment vars
#
# I couldn't get vanilla virtualenvwrapper working with pyenv, because
# the pyenv shims always exec the files in 'bin', which doesn't work
# with virtualenvwrapper.sh and virtualenvwrapper_lazy.sh, since they
# are intended to be sourced. Thus, I switched to using the
# pyenv-virtualenv plugin instead of virtualenvwrapper.
#
# pyenv should use pyvenv rather than virtualenv
export USE_PYVENV="1"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"
export WORKON_HOME="/v"
# pip should use same dir for venvs as virtualenvwrapper
# TODO: probably not needed with pyenv
export PIP_VIRTUALENV_BASE="${WORKON_HOME}"
# make pip detect an active virtualenv and install to it,
# without having to pass it the -E parameter.
# TODO: probably not needed with pyenv
export PIP_RESPECT_VIRTUALENV=true

# add directory for custom functions/completions to fpath
fpath=("${ZDOTDIR}/functions" $fpath)

## sublimeconf: filetype=shell
