#!/bin/bash

cat<<EOF

                      SCNR installer
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         by Tasos Laskos <tasos.laskos@ecsypno.com>
-------------------------------------------------------------------------

EOF

scnr_dir_name="scnr-1.0dev-1.0dev-1.0dev"
scnr_url="https://downloads.ecsypno.com/scnr-1.0dev-1.0dev-1.0dev-linux-x86_64.tar.gz"
scnr_package="/tmp/scnr.tar.gz"
scnr_pg_user="scnr-pro"

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
osInfo[/etc/SuSE-release]=zypper
osInfo[/etc/debian_version]=apt-get

package_manager=''
for f in ${!osInfo[@]}
do
    if [[ -f $f ]];then
        package_manager=${osInfo[$f]}
    fi
done

chrome_package="/tmp/google-chrome."

case $package_manager in
  apt-get)
    chrome_url="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    chrome_package="${chrome_package}deb"

    echo -n "Downloading Google Chrome, please wait..."
    curl -s $chrome_url > $chrome_package
    handle_failure
    echo "done."

    echo -n "Installing Google Chrome, please wait..."
    sudo apt-get update 2>> $log 1>> $log
    handle_failure
    sudo apt-get -y install $chrome_package 2>> $log 1>> $log
    handle_failure
    echo "done."

    echo -n "Installing PostgreSQL, please wait..."
    sudo apt-get -y install postgresql 2>> $log 1>> $log
    handle_failure
    echo "done."

    echo
    echo -n "Starting PostgreSQL..."
    sudo service postgresql start
    handle_failure
    echo "done."

    ;;

  yum)
    chrome_url="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    chrome_package="${chrome_package}rpm"

    echo -n "Downloading Google Chrome, please wait..."
    curl -s $chrome_url > $chrome_package
    handle_failure
    echo "done."

    echo -n "Installing Google Chrome, please wait..."
    sudo yum -y install $chrome_package 2>> $log 1>> $log
    handle_failure
    echo "done."

    echo -n "Installing PostgreSQL, please wait..."
    sudo yum -y install postgresql-server 2>> $log 1>> $log
    handle_failure
    echo "done."

    echo -n "Initialising PostgreSQL, please wait..." 2>> $log 1>> $log
    sudo postgresql-setup --initdb 2>> $log 1>> $log
    echo "done."

    echo
    echo -n "Starting PostgreSQL..."
    sudo systemctl start postgresql.service 2>> $log 1>> $log
    handle_failure
    echo "done."
    ;;

  zypper)
    chrome_url="https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"
    chrome_package="${chrome_package}rpm"

    echo -n "Downloading Google Chrome, please wait..."
    curl -s $chrome_url > $chrome_package
    handle_failure
    echo "done."

    echo -n "Installing Google Chrome, please wait..."
    sudo zypper --non-interactive --no-gpg-checks --quiet install --auto-agree-with-licenses $chrome_package 2>> $log 1>> $log
    handle_failure
    echo "done."

    echo -n "Installing PostgreSQL, please wait..."
    sudo zypper --non-interactive --no-gpg-checks --quiet install --auto-agree-with-licenses postgresql-server 2>> $log 1>> $log
    handle_failure
    echo "done."

    echo
    echo -n "Starting PostgreSQL..."
    sudo systemctl start postgresql.service 2>> $log 1>> $log
    handle_failure
    echo "done."

    ;;

  *)
    echo "No supported package manager found, please follow a manual installation process."
    exit 1
    ;;
esac

rm $chrome_package

echo -n "Downloading SCNR, please wait..."
curl -s $scnr_url > $scnr_package
handle_failure
echo "done."

echo -n "Installing SCNR, please wait..."
rm -rf ~/$scnr_dir_name
tar xf $scnr_package -C ~/
rm $scnr_package
echo -n "done."

echo

cd ~/$scnr_dir_name

user_exists=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$scnr_pg_user'" 2>> $log)

if [ $user_exists -eq 1 ]; then
    echo "PostgeSQL user '$scnr_pg_user' already exists."
else
    echo "Creating PostgeSQL user '$scnr_pg_user', please enter and remember the password."
    sudo -u postgres createuser -s $scnr_pg_user -P
    handle_failure
fi

xdg-open .system/scnr-ui-pro/config/database.yml
read -p "Please update the DB configuration for user '$scnr_pg_user' and press enter to continue..."
echo
echo -n "Creating DB..."
./bin/scnr_pro_task db:create 2>> $log 1>> $log
handle_failure
echo "done."

echo -n "Migrating DB..."
./bin/scnr_pro_task db:migrate 2>> $log 1>> $log
echo "done."
handle_failure

echo -n "Seeding DB..."
./bin/scnr_pro_task db:seed 2>> $log 1>> $log
echo "done."

echo
echo -n "SCNR installed at:   "
echo ~/$scnr_dir_name
echo "Installation log at: $log"
