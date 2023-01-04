#!/usr/bin/env bash

# fedora toolbox install script

set -euxo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

toolbox_dependencies=$(cat toolbox-dependencies | sed 's/#.*//')
extra_packages=$(cat extra-packages | sed 's/#.*//')
installed_packages=$(dnf list installed | awk '{print $1}' | tail -n +2)

# reconfigure dnf to allow docs
sed -i '/tsflags=nodocs/d' /etc/dnf/dnf.conf

# use coreutils-full instaed of coreutils-single
dnf -y swap coreutils-single coreutils-full

# preinstalled packages need reinstalled to get manpages working
dnf -y reinstall $installed_packages

# update packages
dnf -y update

# install everything
dnf -y install \
  $toolbox_dependencies \
  $extra_packages

# clear pkg cache
dnf clean all
