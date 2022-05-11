# SCNR Installer

Installation instructions for [SCNR](https://ecsypno.com/scnr-documentation/) on Mac OS X,
Debian-based, RedHat-based or SuSE Linux distributions.

## Automated installation

To install run the following command in a terminal of your choice:

```bash
bash -c "$(curl -sSL https://raw.githubusercontent.com/scnr/installer/main/install.sh)"
```

It will also install:
* Linux
  * [Google Chrome](https://www.google.com/chrome/)
    * To resolve its dependencies for the _Engine_.
  * [PostgreSQL](https://www.postgresql.org/) -- For the _Pro_ WebUI.
      * It **will not** create a DB role, that is up to the user. 
* OS X
  * [curl](https://curl.se/) -- For the _Engine_.
  * [PostgreSQL](https://www.postgresql.org/) -- For the _Pro_ WebUI.
    * It **will not** create a DB role, that is up to the user.

### Pro WebUI

#### Database connection

If you choose to setup the DB during installation, you will be asked to edit 
`.system/scnr-ui-pro/config/database.yml` and update
it with your [PostgreSQL](https://www.postgresql.org/) credentials.

Please make sure that you create an appropriate DB role prior to continuing with
the automated DB setup.

You can also skip the DB setup during installation and do it manually at a later time.

#### Database setup

To setup the DB at a later time please issue the following command after the
correct configuration of credentials has taken place:

```
bin/scnr_pro_task db:create db:migrate db:seed
```

## Manual installation

1. Download the [package](https://downloads.ecsypno.com/) for your OS.
2. Extract.
   1. Linux
      1. Install [Google Chrome](https://www.google.com/chrome/) to resolve its dependencies.
   2. OSX
      1. If you encounter a `libcurl` error please install it.
3. Install [PostgreSQL](https://www.postgresql.org/) for _Pro_ if you wish to use it.
   1. Create a DB role for _Pro_.
   2. Edit: `.system/scnr-ui-pro/config/database.yml`
   3. `bin/scnr_pro_task db:create db:migrate db:seed`

## License

Copyright [Ecsypno](https://ecsypno.com/). 
All rights reserved.
