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
for package in $(find . -mindepth 1 -maxdepth 1 -type d ! -name '.git' | cut -c 3- | sort); do
    set -x
    stow --target="${STOW_TARGET}" "${package}"
    { set +x &>/dev/null; } &>/dev/null
done
