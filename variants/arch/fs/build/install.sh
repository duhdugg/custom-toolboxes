#!/usr/bin/env bash

# arch toolbox install script

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

function run {
  echo "install.sh: $@"
  "$@" || exit 1
}

toolbox_dependencies=$(cat toolbox-dependencies | sed 's/#.*//')
extra_packages=$(cat extra-packages | sed 's/#.*//')
# preinstalled packages need reinstalled to get manpages working
installed_packages=$(pacman -Qq)

# sync package db
run pacman -Sy

# install everything
run pacman -Su --noconfirm \
  $toolbox_dependencies \
  $extra_packages \
  $installed_packages

# clear pkg cache
run pacman -Scc
