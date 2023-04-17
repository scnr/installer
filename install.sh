#!/usr/bin/env bash

alias curl="curl -f --retry 12 --retry-all-errors"

cat<<EOF

                      SCNR installer
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         by Tasos Laskos <tasos.laskos@ecsypno.com>
-------------------------------------------------------------------------

EOF

if (( UID == 0 )); then
    echo "Cannot run as root!"
    exit 1
else
    sudo="sudo"

    sudo -p "Please enter root password: " -S test true

    if [[ $? -ne 0 ]]; then
      echo "SUDO failed."
      exit 1
    fi

    echo
fi

#
# Checks the last return value and exits with an error message on failure.
#
# To be called after each step.
#
handle_failure() {
    rc=$?
    if [[ $rc != 0 ]] ; then
        echo "Installation failed, check $log for details."
        exit $rc
    fi
}

operating_system(){
    uname -s | awk '{print tolower($0)}'
}

architecture(){
    uname -m
}

version() {
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }';
}

print_eula() {
    cat<<EOF

  Copyright 2023 Tasos Laskos <tasos.laskos@gmail.com>.
  ALL rights reserved.

  This software is provided "AS IS" and purely for demonstration/evaluation purposes
  and is by no means to be used for commercial or harmful actions.

  Reverse engineering of this software is strictly prohibited!

EOF

latest_release=$(curl -fsS https://downloads.ecsypno.com/scnr/LATEST_RELEASE 2> /dev/null)
if [[ $? == 22 ]] ; then
    echo
    echo "*********************************************************"
    echo "Server is undergoing maintenance, please try again later."
    echo "*********************************************************"
    echo
    exit 2
fi

agree=""
read -p "Input \"I AGREE\" to accept: " agree

if [[ "$agree" != "I AGREE" ]]; then
  exit
fi

echo
}

print_eula

if [[ "$(operating_system)" == "darwin" ]]; then
    osx_supported_min="10.15.7"
    osx_current=$(sw_vers -productVersion)

    if [ $(version $osx_current) -lt $(version $osx_supported_min) ]; then
        echo "OS X version $osx_current is not supported, supported versions are >= $osx_supported_min."
        exit 1
    fi
fi

log=./scnr.install.log

yum_cmd=$(which yum)
apt_get_cmd=$(which apt-get)
zypper_cmd=$(which zypper)
brew_cmd=$(which brew)

if [[ ! -z $yum_cmd ]]; then
    package_manager="yum"
elif [[ ! -z $apt_get_cmd ]]; then
    package_manager="apt-get"
elif [[ ! -z $zypper_cmd ]]; then
    package_manager="zypper"
elif [[ ! -z $brew_cmd ]]; then
    package_manager="brew"
else
    echo "No supported package manager found, please follow a manual installation process."
    exit 1
fi

chrome_package="/tmp/google-chrome."

case $package_manager in
  apt-get)
    chrome_url="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    chrome_package="${chrome_package}deb"

    echo "(1/2) Handling dependencies"
    echo -n "   * Downloading Chrome..."
    curl -so $chrome_package $chrome_url
    handle_failure
    echo "done."

    echo -n "   * Installing..."
    $sudo apt-get update 2>> $log 1>> $log
    handle_failure
    $sudo apt-get -y install $chrome_package 2>> $log 1>> $log
    handle_failure
    echo "done."
    rm $chrome_package
    ;;

  yum)
    chrome_url="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    chrome_package="${chrome_package}rpm"

    echo "(1/2) Handling dependencies"
    echo -n "   * Downloading Chrome..."
    curl -so $chrome_package $chrome_url
    handle_failure
    echo "done."

    echo -n "   * Installing..."
    $sudo yum -y install $chrome_package 2>> $log 1>> $log
    handle_failure
    echo "done."
    rm $chrome_package
    ;;

  zypper)
    chrome_url="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    chrome_package="${chrome_package}rpm"

    echo "(1/2) Handling dependencies"
    echo -n "   * Downloading Chrome..."
    curl -so $chrome_package $chrome_url
    handle_failure
    echo "done."

    echo -n "   * Installing..."
    $sudo zypper --non-interactive --no-gpg-checks --quiet install --auto-agree-with-licenses curl $chrome_package 2>> $log 1>> $log
    handle_failure
    echo "done."
    rm $chrome_package
    ;;

  brew)

    echo "(1/2) Handling dependencies"
    echo -n "   * Installing..."
    brew install curl 2>> $log 1>> $log
    handle_failure
    echo "done."
    ;;
esac

scnr_dir="./$latest_release"
scnr_url="https://downloads.ecsypno.com/scnr/scnr-latest-$(operating_system)-$(architecture).tar.gz"
scnr_package="/tmp/$latest_release.tar.gz"
scnr_db_config="$scnr_dir/.system/scnr-ui-pro/config/database.yml"

echo
echo "(2/2) SCNR"

echo -n "   * Downloading..."
curl -so $scnr_package $scnr_url
handle_failure
echo "done."

echo -n "   * Installing..."
mkdir $scnr_dir
tar xf $scnr_package -C $scnr_dir
handle_failure
rm $scnr_package
echo "done."

db="$HOME/.scnr/pro/db/production.sqlite3"

if [[ -f "$db" ]]; then
    echo -n "   * Updating the DB..."
    $scnr_dir/scnr-*/bin/scnr_pro_task db:migrate 2>> $log 1>> $log
    handle_failure
else
    echo -n "   * Setting up the DB..."
    $scnr_dir/scnr-*/bin/scnr_pro_task db:create db:migrate db:seed 2>> $log 1>> $log
    handle_failure
fi
echo "done."

echo
echo
echo -n "SCNR installed at:   "
echo $scnr_dir
echo "Installation log at: $log"
