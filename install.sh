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

print_db_config_info() {
    echo "   * You can edit the DB config file later:"
    echo "       $scnr_db_config"
    echo "   * Then issue:"
    echo "       $scnr_dir/bin/scnr_pro_task db:create db:migrate db:seed"
}

version() {
    echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }';
}

if [[ "$(operating_system)" == "darwin" ]]; then
    osx_supported_min="12.3.1"
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

    echo "(1/4) Google Chrome"
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

    echo
    echo "(2/4) PostgreSQL"
    echo -n "   * Installing..."
    $sudo apt-get -y install postgresql 2>> $log 1>> $log
    handle_failure
    echo "done."

    echo -n "   * Starting..."
    $sudo service postgresql start
    handle_failure
    echo "done."
    ;;

  yum)
    chrome_url="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    chrome_package="${chrome_package}rpm"

    echo "(1/4) Google Chrome"
    echo -n "   * Downloading..."
    curl -s $chrome_url > $chrome_package
    handle_failure
    echo "done."

    echo -n "   * Installing..."
    $sudo yum -y install $chrome_package 2>> $log 1>> $log
    handle_failure
    echo "done."
    rm $chrome_package

    echo
    echo "(2/4) PostgreSQL"
    echo -n "   * Installing..."
    $sudo yum -y install postgresql-server 2>> $log 1>> $log
    handle_failure
    echo "done."

    echo -n "   * Initialising..."
    $sudo postgresql-setup --initdb 2>> $log 1>> $log
    echo "done."

    echo -n "   * Starting..."
    $sudo systemctl start postgresql.service 2>> $log 1>> $log
    handle_failure
    echo "done."
    ;;

  zypper)
    chrome_url="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    chrome_package="${chrome_package}rpm"

    echo "(1/4) Google Chrome"
    echo -n "   * Downloading..."
    curl -s $chrome_url > $chrome_package
    handle_failure
    echo "done."

    echo -n "   * Installing..."
    $sudo zypper --non-interactive --no-gpg-checks --quiet install --auto-agree-with-licenses $chrome_package 2>> $log 1>> $log
    handle_failure
    echo "done."
    rm $chrome_package

    echo
    echo "(2/4) PostgreSQL"
    echo -n "   * Installing..."
    $sudo zypper --non-interactive --no-gpg-checks --quiet install --auto-agree-with-licenses postgresql-server 2>> $log 1>> $log
    handle_failure
    echo "done."

    echo -n "   * Starting..."
    $sudo systemctl start postgresql.service 2>> $log 1>> $log
    handle_failure
    echo "done."
    ;;

  brew)

    # Keep the stage counter even, heh...
    echo "(1/4) Initializing...done."
    echo

    echo "(2/4) PostgreSQL"
    echo -n "   * Installing..."
    brew install postgresql 2>> $log 1>> $log
    handle_failure
    echo "done."

    echo -n "   * Starting..."
    brew services start postgresql 2>> $log 1>> $log
    handle_failure
    echo "done."
    ;;
esac

echo
echo "(3/4) SCNR"

echo -n "   * Downloading..."
curl -s $scnr_url > $scnr_package
handle_failure
echo "done."

echo -n "   * Installing..."
rm -rf "$scnr_dir"
tar xf $scnr_package -C ~/
rm $scnr_package
echo -n "done."

echo

cd "$scnr_dir"

echo

if [[ -t 0 ]]; then
    read -p "(4/4) Setup DB for Pro WebUI now? (y/N): " setup_now

    if [ "$setup_now" = "y" ]; then

        if [ $(operating_system) = "darwin" ]; then
            open $scnr_db_config
        else
            xdg-open $scnr_db_config
        fi

        read -p "   * Please update the DB configuration and press enter to continue..."
        echo -n "   * Setting up the DB..."
        ./bin/scnr_pro_task db:create db:migrate 2>> $log 1>> $log

        if [ $? != 0 ]; then
            echo "failed, check log for details."
            print_db_config_info
        else
            # This can fail if the DB has already been seeded but it's not an issue.
            ./bin/scnr_pro_task db:seed 2>> $log 1>> $log
            echo "done."
        fi

    else
        print_db_config_info
    fi

else
    echo "(4/4) Shell is non-interactive, skipping DB setup."
    print_db_config_info
fi


echo
echo -n "SCNR installed at:   "
echo $scnr_dir
echo "Installation log at: $log"
