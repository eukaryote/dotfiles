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
# ignore completion function for functions we don't have:
zstyle ':completion:*:functions' ignored-patterns '_*'
# use cache, which helps with some functions that are very slow:
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache
# remove trailing slash when using directory as an argument:
zstyle ':completion:*' squeeze-slashes true

function xinput() {
    echo "disabled"
    return 1
}

function source-if-exists {
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
    mybin="$HOME/bin"
    if [[ "${path[0]}" = "${mybin}" ]]
    then
        path=(${path[@]:2})
    fi
    eval "$(${PYENV_ROOT:-$HOME/.pyenv}/bin/pyenv init -)"
    pyenv virtualenvwrapper_lazy
    path=(${mybin} ${path})
fi

# Find non-empty duplicate files in a directory.
#
# If no directory arg is provided as the first param (subsequent
# params ignored), then it defaults to the current working directory.
# The '.directory' files that are added by Dolphin are ignored.
finddupes() {
    find "${1:-.}" -not -name '.directory' -and -not -empty -type f -printf "%s\n" | \
        sort -rn | \
        uniq -d | \
        xargs -I{} -n1 find -type f -size {}c -print0 | \
        xargs -0 sha256sum | \
        sort | \
        uniq -w64 --all-repeated=separate
}


# Initialize my chpwd script that will activate a virtualenv when entering
# a directory that contains a .venv file with the name of a virtualenv inside
# (or entering a descendent of such a directory) and deactivate the virtualenv
# when changing to a directory not inside the virtualenv.
source-if-exists "${SCRIPTDIR}/chpwd.zsh"

# pickup cabal helper aliases if present:
source-if-exists "$HOME/repos/ghcPkgUtils/ghcPkgUtils.sh"

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
    . $HOME/.nix-profile/etc/profile.d/nix.sh;
fi

export RPROMPT='%(?..%B%F{red}%? ↵%b%{%})'

autoload -Uz compinit promptinit
compinit -d $HOME/.zcompdump
promptinit
#prompt eukaryote
prompt pure
autoload -U colors && colors

# Use emacs mode
bindkey -e

# "escape #": toggle '#' at beginning of line
bindkey '\e#' vi-pound-insert

bindkey '^q' push-line-or-edit

# Autoload all non-completion functions.
if [[ -d "${ZDOTDIR}/functions" ]]; then
    for func in $(ls -1 ${ZDOTDIR}/functions); do
        if [[ ! "${func}" =~ '_.*' ]]; then
            autoload -Uz ${func}
        fi
    done
fi

source-if-exists "${ZDOTDIR}/.aliases.zsh"
source-if-exists "${ZDOTDIR}/.aliases-git"

# Distro-specific aliases
[[ -s "/etc/redhat-release" ]] && source-if-exists "${ZDOTDIR}/.aliases-redhat"
[[ -s "/etc/debian_version" ]] && source-if-exists "${ZDOTDIR}/.aliases-debian"

# Custom aliases that are host specific and not in git:
source-if-exists "${ZDOTDIR}/.aliases-custom"

# Initialize zsh-syntax-highlighting if present. This must be last in .zshrc.
source-if-exists "${REPODIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

if [[ -n "${commands[kubectl]}" ]]; then
   source <(${commands[kubectl]} completion zsh)
fi

if which tmuxp >/dev/null 2>&1 ; then
    eval "$(_TMUXP_COMPLETE=source tmuxp)"
fi

autoload -U +X bashcompinit && bashcompinit
complete -C /opt/terraform/default/terraform terraform

source-if-exists "$HOME/.fzf.zsh"
#source-if-exists "/usr/share/google-cloud-sdk/completion.zsh.inc"

## sublimeconf: filetype=shell
