# Execute commands at start of interactive session (login and non-login).
#
# This is sourced after env (for interactive login and non-login sessions)
# and after zprofile (for interactive login sessions) and before zlogin
# (for interactive login sessions).

# ===== Basics
setopt no_beep # don't beep on error
setopt interactive_comments # Allow comments even in interactive shells
setopt notify # report status of background jobs immediately

# ===== Changing Directories
unsetopt auto_cd # disable `foo` as abbr for `cd foo` when 'foo' is in cdpath
setopt cdablevars # can cd to $foo using `cd foo` if $foo is a valid directory
unsetopt pushd_ignore_dups # allow pushd dups
setopt auto_pushd  # push old dir onto stack on cd
setopt pushd_silent # don't print on push
setopt pushd_to_home # push to home when no arg given

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

function xinput() {
    echo "disabled"
    return 1
}

function source-if {
    for p in "$@"; do
        if [[ -f "$p" ]]; then
            source "$p"
        fi
    done
}

# Initalize virtualenvwrapper via the pyenv-virtualenvwrapper plugin;
# I had problems getting this to work when pyenv was checked out into
# ~/repos and symlinked to ~/.pyenv, so now pyenv is checked out to
# ~/.pyenv and symlinked to ~/repos/pyenv.
# In order for this to work, the pyenv-virtualenvwrapper plugin needs to
# exist in ~/.pyenv/plugins.
if [[ -s "${PYENV_ROOT:-$HOME/.pyenv}/bin/pyenv" ]]; then
    path=("${PYENV_ROOT:-$HOME/.pyenv}/bin" $path)
    eval "$(pyenv init -)"
    pyenv virtualenvwrapper_lazy
fi

# Initialize my chpwd script that will activate a virtualenv when entering
# a directory that contains a .venv file with the name of a virtualenv inside
# (or entering a descendent of such a directory) and deactivate the virtualenv
# when changing to a directory not inside the virtualenv.
source "${SCRIPTDIR}/chpwd.zsh"

# pickup cabal helper aliases if present:
source-if "$HOME/repos/ghcPkgUtils/ghcPkgUtils.sh"

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
    . $HOME/.nix-profile/etc/profile.d/nix.sh;
fi

export RPROMPT='%(?..%B%F{red}%? ↵%b%{%})'

autoload -Uz compinit promptinit
compinit -d $HOME/.zcompdump
promptinit
prompt eukaryote
autoload -U colors && colors

# Use emacs mode
bindkey -e

# Autoload all non-completion functions.
if [[ -d "${ZDOTDIR}/functions" ]]; then
    for func in $(ls -1 ${ZDOTDIR}/functions); do
        if [[ ! "${func}" =~ '_.*' ]]; then
            autoload -Uz ${func}
        fi
    done
fi

source ${ZDOTDIR}/.aliases.zsh
source ${ZDOTDIR}/.aliases-git

# Initialize zsh-syntax-highlighting if present. This must be last in .zshrc.
source-if "${REPODIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

if [[ -n "${commands[kubectl]}" ]]; then
   source <(${commands[kubectl]} completion zsh)
fi

if which tmuxp >/dev/null 2>&1 ; then
    eval "$(_TMUXP_COMPLETE=source tmuxp)"
fi


## sublimeconf: filetype=shell
