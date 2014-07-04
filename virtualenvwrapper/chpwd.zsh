# Source this during zsh initialization, and add a '.venv' file to a
# virtualenvwrapper project directory that contains, putting the name of the
# virtualenv or venv inside the '.venv' file, and when you cd into the
# directory, 'workon' will be called to activate the environment if it's not
# already activated.


# After each change of directory in zsh, check to see if there's a '.venv'
# file, and if there is, then activate the virtualenv that is named inside
# the file.

# Might be able to use the VIRTUAL_ENV var instead now, but needs testing
_chpwd_venv_dir=""

chpwd_check_deactivation() {
    local venv_deactivating
    # return immediately if we're already deactivating
    [[ -n "${_venv_deactivating}" ]] && return 0
    # or the venv dir wasn't recorded
    [[ -z  "${_chpwd_venv_dir}" ]] && return 0
    # or there is no deactivate function defined
    ( type deactivate > /dev/null 2>&1 ) || return 0
    # or the new directory is a descendent of the virtualenv dir
    [[ ("$(pwd)" =~ "${_chpwd_venv_dir}(\$|/)" ) ]] && return 0

    _chpwd_venv_dir=""
    venv_deactivating=1
    deactivate
    venv_deactivating=""
}

chpwd() {
    emulate -L zsh

    local activating

    if [[ -n "${activating}" ]]
    then
        return 0
    else
        activating=1
    fi

    chpwd_check_deactivation

    if [[ ! -s .venv ]]
    then
        activating=""
        return 0
    fi

    local venv="$(cat .venv 2> /dev/null)"
    if [[ -d "${WORKON_HOME}/${venv}" ]]
    then
        if [[ "${venv}" !=  "${VIRTUAL_ENV##*/}" ]]
        then
            workon "${venv}"
        fi
        # still need to set the venv dir even if the venv was already
        # activated, because it might have been activated by virtualenvwrapper
        # when creating the virtualenv rather than via this script, but we
        # wouldn't yet have set the variable, so wouldn't be able to
        # deactivate later.
        _chpwd_venv_dir="$(pwd)"
    fi
    activating=""
}
