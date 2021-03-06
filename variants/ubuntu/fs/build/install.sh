#!/usr/bin/env bash

# ubuntu toolbox install script

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

function run {
  echo "install.sh: $@"
  "$@" || exit 1
}

toolbox_dependencies=$(cat toolbox-dependencies | sed 's/#.*//')
extra_packages=$(cat extra-packages | sed 's/#.*//')

# sync package db
run apt update -y

# upgrade
run apt upgrade -y

# install dependencies and extras
run apt install -y \
  $toolbox_dependencies \
  $extra_packages

# unminimize
echo "install.sh: yes | unminimize"
yes | unminimize

# clear pkg cache
run apt-get clean
