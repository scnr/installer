#!/usr/bin/env bash

cat<<EOF
                      Codename SCNR installer
-------------------------------------------------------------------------
EOF

if (( UID == 0 )); then
    echo "Cannot run as root!"
    exit 1
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
  Copyright 2023-2024 Ecsypno Single Member P.C. <http://ecsypno.com>.
  ALL rights reserved.

  This software is provided "AS IS" and purely for demonstration/evaluation purposes,
  without any WARRANTIES and is by no means to be used for commercial, illegal or harmful action.

  Should damage arise by the use of this software, the author accepts no responsibility.

  Reverse engineering of this software is strictly prohibited!
EOF

    echo

    agree=""
    read -p "Input \"I AGREE\" to accept: " agree

    if [[ "$agree" != "I AGREE" ]]; then
      exit
    fi

   echo
}

if [[ "$(operating_system)" == "darwin" ]]; then
    echo "OSX is not currently supported."
    exit 1
fi

under_maintenance() {
    echo "Down for maintenance, will be back up shortly..."
    exit
}

#under_maintenance

print_eula

latest_version=`curl -sL https://raw.githubusercontent.com/scnr/version/main/LATEST`
scnr_url="https://github.com/scnr/installer/releases/download/v$latest_version/scnr-v$latest_version-$(operating_system)-$(architecture).tar.gz"
scnr_dir="./scnr-v$latest_version"
scnr_package="./scnr-v$latest_version.tar.gz"
scnr_db_config="$scnr_dir/.system/scnr-ui-pro/config/database.yml"
log=./scnr.install.log

echo

echo "   * Downloading..."
curl -L --retry 12 --retry-delay 1 --retry-all-errors $scnr_url -o $scnr_package
handle_failure

echo -n "   * Installing..."
tar xf $scnr_package
handle_failure
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
