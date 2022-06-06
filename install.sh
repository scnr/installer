#!/usr/bin/env bash

cat<<EOF

                      SCNR installer
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         by Tasos Laskos <tasos.laskos@ecsypno.com>
-------------------------------------------------------------------------

EOF

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

if [[ "$(operating_system)" == "darwin" ]]; then
    osx_supported_min="10.15.7"
    osx_current=$(sw_vers -productVersion)

    if [ $(version $osx_current) -lt $(version $osx_supported_min) ]; then
        echo "OS X version $osx_current is not supported, supported versions are >= $osx_supported_min."
        exit 1
    fi
fi

# In case of Docker or already being root.
if (( UID == 0 )); then
    sudo=""
else
    sudo="sudo"
fi

scnr_dir=~/scnr-1.0dev-1.0dev-1.0dev
scnr_url="https://downloads.ecsypno.com/scnr-1.0dev-1.0dev-1.0dev-$(operating_system)-$(architecture).tar.gz"
scnr_package="/tmp/scnr.tar.gz"
scnr_db_config="$scnr_dir/.system/scnr-ui-pro/config/database.yml"
log=~/scnr.install.log

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

    echo "(1/2) Google Chrome"
    echo -n "   * Downloading..."
    curl -s $chrome_url > $chrome_package
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

    echo "(1/2) Google Chrome"
    echo -n "   * Downloading..."
    curl -s $chrome_url > $chrome_package
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

    echo "(1/2) Google Chrome"
    echo -n "   * Downloading..."
    curl -s $chrome_url > $chrome_package
    handle_failure
    echo "done."

    echo -n "   * Installing..."
    $sudo zypper --non-interactive --no-gpg-checks --quiet install --auto-agree-with-licenses $chrome_package 2>> $log 1>> $log
    handle_failure
    echo "done."
    rm $chrome_package
    ;;

  brew)

    echo "(1/2) curl"
    echo -n "   * Installing..."
    brew install curl 2>> $log 1>> $log
    handle_failure
    echo "done."
    ;;
esac

echo
echo "(2/2) SCNR"

echo -n "   * Downloading..."
curl -s $scnr_url > $scnr_package
handle_failure
echo "done."

rm -rf "$scnr_dir.bak"
mv "$scnr_dir" "$scnr_dir.bak" 2>> $log 1>> $log

echo -n "   * Installing..."
tar xf $scnr_package -C ~/
rm $scnr_package
echo "done."

db="$HOME/.scnr/pro/db/production.sqlite3"

if [[ -f "$db" ]]; then
    echo -n "   * Updating the DB..."
    $scnr_dir/bin/scnr_pro_task db:migrate 2>> $log 1>> $log
    handle_failure
else
    echo -n "   * Setting up the DB..."
    $scnr_dir/bin/scnr_pro_task db:create db:migrate db:seed 2>> $log 1>> $log
    handle_failure
fi
echo "done."

echo
echo
echo -n "SCNR installed at:   "
echo $scnr_dir
echo "Installation log at: $log"
