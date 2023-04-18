# SCNR Installer

Installation instructions for [SCNR](https://ecsypno.com/scnr-documentation/) on
Debian-based, RedHat-based or SuSE Linux distributions.

## Automated installation

To install run the following command in a terminal of your choice:

```bash
bash -c "$(curl -sSL https://raw.githubusercontent.com/scnr/installer/main/install.sh)"
```

It will also install [Google Chrome](https://www.google.com/chrome/) 
to resolve its dependencies for the _Engine_.

## Manual installation

1. Download the [package](https://downloads.ecsypno.com/).
2. Extract.
3. Install [Google Chrome](https://www.google.com/chrome/) to resolve its dependencies.

### SCNR WebUI

If you'd like to use SCNR WebUI, its database will need to be prepared.

Out of the box, the WebUI comes configured with [SQLite](https://sqlite.org/index.html), however,
for better results and performance please switch to [PostgreSQL](https://www.postgresql.org/).

#### Setup

If this is a fresh installation, you can setup a DB with:

    ./bin/scnr_pro_task db:create db:migrate db:seed

#### Update

If you'd like to update an existing installation you can do it with:

    ./bin/scnr_pro_task db:migrate

#### PostgreSQL

##### Configuration

Please exchange `secret` with a secure password.

###### Role creation

```
$ sudo -u postgres psql
postgres=# CREATE USER "scnr-pro" WITH PASSWORD 'secret';
postgres=# ALTER USER "scnr-pro" superuser;
```

###### Connection

```
mv .system/scnr-ui-pro/config/database.yml .system/scnr-ui-pro/config/database.yml.bak
cp .system/scnr-ui-pro/config/database.postgres.yml .system/scnr-ui-pro/config/database.yml
```

Now edit `.system/scnr-ui-pro/config/database.yml` to change the password from `secret`.

## License

Copyright 2023 [Ecsypno Single Member P.C.](https://ecsypno.com/).

All rights reserved.
