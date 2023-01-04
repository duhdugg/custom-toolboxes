#!/usr/bin/env bash

# arch-testing toolbox install script

set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

toolbox_dependencies=$(cat toolbox-dependencies | sed 's/#.*//')
extra_packages=$(cat extra-packages | sed 's/#.*//')
# preinstalled packages need reinstalled to get manpages working
installed_packages=$(pacman -Qq)

# sync package db
pacman -Sy

# install everything
pacman -Su --noconfirm \
  $toolbox_dependencies \
  $extra_packages \
  $installed_packages

# clear pkg cache
pacman -Scc
