#!/bin/bash
#
# A script to bootstrap crew.
# It expects to be run on Ubuntu 14.04 via 'sudo'
# If installing a tag higher than 0.3.13, it may install crew via a package (so long as the package is higher than 0.3.13)
# It checks out the crew source code from Github into ~/crew and then runs 'make install' from crew source.

set -eo pipefail
export DEBIAN_FRONTEND=noninteractive
export CREW_REPO=${CREW_REPO:-"https://github.com/progrium/crew.git"}

if ! command -v apt-get &>/dev/null; then
  echo "This installation script requires apt-get. For manual installation instructions, consult http://progrium.viewdocs.io/crew/advanced-installation ."
  exit 1
fi

apt-get update
which curl > /dev/null || apt-get install -qq -y curl
[[ $(lsb_release -sr) == "12.04" ]] && apt-get install -qq -y python-software-properties

crew_install_source() {
  apt-get install -qq -y git make software-properties-common
  cd /root
  if [ ! -d /root/crew ]; then
    git clone $CREW_REPO /root/crew
  fi

  cd /root/crew
  git fetch origin
  git checkout $CREW_CHECKOUT
  make install
}

crew_install_package() {
  curl -sSL https://get.docker.io/gpg | apt-key add -
  curl -sSL https://packagecloud.io/gpg.key | apt-key add -

  echo "deb http://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
  echo "deb https://packagecloud.io/crew/crew/ubuntu/ trusty main" > /etc/apt/sources.list.d/crew.list

  sudo apt-get update > /dev/null
  sudo apt-get install -qq -y "linux-image-extra-$(uname -r)" apt-transport-https

  if [[ -n $CREW_CHECKOUT ]]; then
    sudo apt-get install -qq -y crew=$CREW_CHECKOUT
  else
    sudo apt-get install -qq -y crew
  fi
}

if [[ -n $CREW_BRANCH ]]; then
  export CREW_CHECKOUT="origin/$CREW_BRANCH"
  crew_install_source
elif [[ -n $CREW_TAG ]]; then
  export CREW_SEMVER="${CREW_TAG//v}"
  major=$(echo $CREW_SEMVER | awk '{split($0,a,"."); print a[1]}')
  minor=$(echo $CREW_SEMVER | awk '{split($0,a,"."); print a[2]}')
  patch=$(echo $CREW_SEMVER | awk '{split($0,a,"."); print a[3]}')

  # 0.3.13 was the first version with a debian package
  if [[ "$major" -eq "0" ]] && [[ "$minor" -lt "4" ]] && [[ "$patch" -lt "13" ]]; then
    export CREW_CHECKOUT="$CREW_TAG"
    crew_install_source
  else
    export CREW_CHECKOUT="$CREW_SEMVER"
    crew_install_package
  fi
else
  crew_install_package
fi
