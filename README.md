# Codename SCNR Installer

Installation instructions for [Codename SCNR](https://ecsypno.com/pages/codename-scnr) on Linux
x86 64bit.

## Automated installation

To install run the following command in a terminal of your choice:

```bash
bash -c "$(curl -sSL https://get.ecsypno.com/scnr)"
```

## Manual installation

1. [Buy a license activation key](https://ecsypno.com/)  -- if you haven't already done so for a previous release.
2. Download the [latest package](https://github.com/scnr/installer/releases).
3. Extract.
4. Run `bin/scnr_activate KEY` to activate your installation -- if you haven't already done so for a previous release.

### SCNR WebUI

If you'd like to use the Codename SCNR WebUI, its database will need to be prepared.

Out of the box, the WebUI comes configured with [SQLite](https://sqlite.org/index.html), however,
for better results and performance please switch to [PostgreSQL](https://www.postgresql.org/).

#### PostgreSQL

##### Configuration

Please exchange `secret` with a secure password in the role creation commands.

###### Role creation

```
$ sudo -u postgres psql
postgres=# CREATE USER "scnr-pro" WITH PASSWORD 'secret';
postgres=# ALTER USER "scnr-pro" superuser;
```

###### Connection

From the package root directory:

```
# Backup SQLite config.
mv .system/scnr-ui-pro/config/database.yml .system/scnr-ui-pro/config/database.yml.bak

# Set to use PostgreSQL config.
cp .system/scnr-ui-pro/config/database.postgres.yml .system/scnr-ui-pro/config/database.yml
```

Now edit `.system/scnr-ui-pro/config/database.yml` to change the password from `secret`.

#### Setup

If this is a fresh installation, you can setup a DB with:

    ./bin/scnr_pro_task db:create db:migrate db:seed

#### Update

If you'd like to update an existing installation you can do it with:

    ./bin/scnr_pro_task db:migrate


## License

Copyright 2023 [Ecsypno Single Member P.C.](https://ecsypno.com/).

All rights reserved.
