#!/usr/bin/env bash

# fedora toolbox install script

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

function run {
  echo "install.sh: $@"
  "$@" || exit 1
}

toolbox_dependencies=$(cat toolbox-dependencies | sed 's/#.*//')
extra_packages=$(cat extra-packages | sed 's/#.*//')
installed_packages=$(dnf list installed | awk '{print $1}' | tail -n +2)

# reconfigure dnf to allow docs
run sed -i '/tsflags=nodocs/d' /etc/dnf/dnf.conf

# use coreutils-full instaed of coreutils-single
run dnf -y swap coreutils-single coreutils-full

# preinstalled packages need reinstalled to get manpages working
run dnf -y reinstall $installed_packages

# update packages
run dnf -y update

# install everything
run dnf -y install \
  $toolbox_dependencies \
  $extra_packages

# clear pkg cache
run dnf clean all
