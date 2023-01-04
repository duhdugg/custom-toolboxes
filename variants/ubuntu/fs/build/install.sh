#!/usr/bin/env bash

# ubuntu toolbox install script

set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

toolbox_dependencies=$(cat toolbox-dependencies | sed 's/#.*//')
extra_packages=$(cat extra-packages | sed 's/#.*//')

# sync package db
apt update -y

# upgrade
apt upgrade -y

# install dependencies and extras
apt install -y \
  $toolbox_dependencies \
  $extra_packages

# unminimize, which for some reason exits with a nonzero exit code even when successful
yes | unminimize && echo ''

# clear pkg cache
apt-get clean
