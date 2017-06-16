#!/usr/bin/env bash

# Run stow on each package in this directory,
# which will add symlinks under ${STOW_TARGET}
# (which defaults to ${HOME}) to the package
# resources.
#
# Every top-level directory in this dotfiles
# repo is considered a stow package to be
# installed, except for the '.git' directory.
#
# To manually install just a single package,
# run stow manually, such as:
# stow package
# stow --target=targetdir package

set -euo pipefail

DOTFILES="$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)"
STOW_TARGET="${STOW_TARGET:-${HOME}}"

cd "${DOTFILES}"
for package in $(find . -mindepth 1 -maxdepth 1 -type d ! -name '.git' -printf '%f\n' | sort)
do
    case "${package}" in
        .git)
            continue
            ;;
        python)
            # copy bin/python symlinks rather than symlinking them
            set -x
            stow --target="${STOW_TARGET}" --ignore 'bin/i?python[0-9]([0-9\.]*)' "${package}"
            cp --force --no-dereference --preserve=links --update python/bin/python* ${STOW_TARGET}/bin/
            cp --force --no-dereference --preserve=links --update python/bin/ipython* ${STOW_TARGET}/bin/
            { set +x >/dev/null 2>&1; } >/dev/null 2>&1
            ;;
        *)
            set -x
            stow --target="${STOW_TARGET}" "${package}"
            { set +x >/dev/null 2>&1; } >/dev/null 2>&1
            ;;
    esac
done
