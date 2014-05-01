# Source this during zsh initialization, and add a '.venv' file to a
# virtualenvwrapper project directory that contains the name of the
# virtualenv or venv, and when you cd into the directory,
# 'workon' will be called to activate the environment if it's not
# already activated.

# After each change of directory in zsh, check to see if there's a '.venv'
# file, and if there is, then activate the virtualenv that is named inside
# the file
chpwd() {
    emulate -L zsh
    if [[ ! -s .venv ]]
    then
        return 0
    fi

    local venv="$(cat .venv)"
    if [[ "${venv}" !=  "${VIRTUAL_ENV##*/}" && -d "${WORKON_HOME}/${venv}" ]]
    then
        workon "${venv}"
    fi
}
