#!/bin/bash

cat<<EOF

                      SCNR installer
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         by Tasos Laskos <tasos.laskos@ecsypno.com>
-------------------------------------------------------------------------

EOF

scnr_dir=~/scnr-1.0dev-1.0dev-1.0dev
scnr_url="https://downloads.ecsypno.com/scnr-1.0dev-1.0dev-1.0dev-linux-x86_64.tar.gz"
scnr_package="/tmp/scnr.tar.gz"
scnr_db_config="$scnr_dir/.system/scnr-ui-pro/config/database.yml"
log=~/scnr.install.log

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

declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/zypp/zypper.conf]=zypper
osInfo[/etc/debian_version]=apt-get

package_manager=''
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        package_manager=${osInfo[$f]}
    fi
done

chrome_package="/tmp/google-chrome."

echo "(1/3) Google Chrome"
case $package_manager in
  apt-get)
    chrome_url="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    chrome_package="${chrome_package}deb"

    echo -n "   * Downloading..."
    curl -s $chrome_url > $chrome_package
    handle_failure
    echo "done."

    echo -n "   * Installing..."
    sudo apt-get update 2>> $log 1>> $log
    handle_failure
    sudo apt-get -y install $chrome_package 2>> $log 1>> $log
    handle_failure
    echo "done."
    ;;

  yum)
    chrome_url="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    chrome_package="${chrome_package}rpm"

    echo -n "   * Downloading..."
    curl -s $chrome_url > $chrome_package
    handle_failure
    echo "done."

    echo -n "   * Installing..."
    sudo yum -y install $chrome_package 2>> $log 1>> $log
    handle_failure
    echo "done."
    ;;

  zypper)
    chrome_url="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    chrome_package="${chrome_package}rpm"

    echo -n "   * Downloading..."
    curl -s $chrome_url > $chrome_package
    handle_failure
    echo "done."

    echo -n "   * Installing..."
    sudo zypper --non-interactive --no-gpg-checks --quiet install --auto-agree-with-licenses $chrome_package 2>> $log 1>> $log
    handle_failure
    echo "done."
    ;;

  *)
    echo "No supported package manager found, please follow a manual installation process."
    exit 1
    ;;
esac

echo

rm $chrome_package

echo "(2/3) SCNR"

echo -n "   * Downloading..."
curl -s $scnr_url > $scnr_package
handle_failure
echo "done."

echo -n "   * Installing..."
rm -rf $scnr_dir
tar xf $scnr_package -C ~/
rm $scnr_package
echo -n "done."

echo

cd $scnr_dir

echo
read -p "(3/3) Setup DB for Pro WebUI now? (y/N): " setup_now

if [ "$setup_now" = "y" ]; then
    xdg-open $scnr_db_config
    read -p "   * Please update the DB configuration and press enter to continue..."
    echo -n "   * Setting up the DB..."
    ./bin/scnr_pro_task db:create db:migrate 2>> $log 1>> $log

    if [ $? != 0 ]; then
        echo "failed, check log for details."
    else
        # This can fail if the DB has already been seeded but it's non an issue.
        ./bin/scnr_pro_task db:seed 2>> $log 1>> $log
        echo "done."
    fi

else
    echo "  * You can edit the DB config file later:"
    echo "      $scnr_db_config"
    echo "  * Then issue:"
    echo "      $scnr_dir/bin/scnr_pro_task db:create db:migrate db:seed"
fi

echo
echo -n "SCNR installed at:   "
echo $scnr_dir
echo "Installation log at: $log"
