# SCNR Installer

Installs [SCNR](https://ecsypno.com/scnr-documentation/) on Mac OS X (>= 12.3.1),
Debian-based, RedHat-based or SuSE Linux distributions.

To install run the following command in a terminal of your choice:

```bash
curl -sSL https://raw.githubusercontent.com/scnr/installer/main/install.sh > /tmp/i.sh && bash /tmp/i.sh
```

It will also install:
* [Google Chrome](https://www.google.com/chrome/) -- For the _Engine_.
* [PostgreSQL](https://www.postgresql.org/) -- For the _Pro_ WebUI.
    * It **will not** create a DB role, that is up to the user. 

## Pro WebUI

### Database connection

If you choose to setup the DB during installation, you will be asked to edit 
`.system/scnr-ui-pro/config/database.yml` and update
it with your [PostgreSQL](https://www.postgresql.org/) credentials.

Please make sure that you create an appropriate DB role prior to continuing with
the automated DB setup.

You can also skip the DB setup during installation and do it manually at a later time.

### Database setup

To setup the DB at a later time please issue the following command after the
correct configuration of credentials has taken place:

```
bin/scnr_pro_task db:create db:migrate db:seed
```


## License

Copyright [Ecsypno](https://ecsypno.com/). 
All rights reserved.
