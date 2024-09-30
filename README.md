# Codename SCNR Installer

Installation instructions for [Codename SCNR](https://ecsypno.com/pages/codename-scnr):

* [Docker installation](#docker-installation) -- for Mac OSX, Linux and MS Windows. _(recommended)_
* [Automated installation](#automated-installation) -- for Linux.
* [Manual installation](#manual-installation) -- for Linux.
* [Dependencies for headless environments or WSL](#dependencies-for-headless-environments-or-wsl)

## Docker installation

Prerequisites:
* [Docker](https://www.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)

```bash
git clone https://github.com/scnr/installer.git codename-scnr-installer
cd codename-scnr-installer

docker compose up -d --build # Start the services.
docker exec -it codename-scnr-app-1 bash # Connect to the container.

# From within the container:
./install.sh # Install Codename SCNR over the network.
```
_In some Linux distributions, you may need to preface the `docker` commands with `sudo`._

You can now run Codename SCNR by using the executables under the `scnr-v*/bin` directory.

1. For a CLI scan you can run `bin/scnr URL`.
2. You can use Codename SCNR Pro by running `bin/scnr_pro`.

For more information please consult the [documentation](https://documentation.ecsypno.com/scnr/).

### Updating

You can run `./install.sh` when a new version is released to install it automatically.

### Caution!

Use `docker compose stop` to stop the container, and `docker compose start` to start it again.

**DO NOT** use `docker compose up` nor `docker compose down`, as they will delete all filesystem
data, including the license.

## Automated installation

To install run the following command in a terminal of your choice:

```bash
bash -c "$(curl -sSL https://get.ecsypno.com/scnr)"
```

You can now run Codename SCNR by using the executables under the `scnr-v*/bin` directory.

1. For a CLI scan you can run `bin/scnr URL`.
2. You can use Codename SCNR Pro by running `bin/scnr_pro`
   1. Setting up PostgreSQL is recommended for production workloads.

For more information please consult the [documentation](https://documentation.ecsypno.com/scnr/).

### PostgreSQL

For a more reliable Codename SCNR Pro experience, it's best to configure it to use PostgreSQL.

Please exchange `secret` with a secure password in the role creation commands.

#### Role creation

```
$ sudo -u postgres psql
postgres=# CREATE USER "scnr-pro" WITH PASSWORD 'secret';
postgres=# ALTER USER "scnr-pro" superuser;
```

#### Connection

```
# Backup SQLite config.
mv ~/.scnr/pro/config/database.yml ~/.scnr/pro/config/database.yml.bak

# Set to use PostgreSQL config.
cp ~/.scnr/pro/config/database.postgres.yml ~/.scnr/pro/config/database.yml
```

Now edit `~/.scnr/pro/config/database.yml` to change the password from `secret`.

#### Setup

From the Codename SCNR package directory:

    bin/scnr_pro_task db:create db:migrate db:seed

## Manual installation

1. Download the [latest package](https://github.com/scnr/installer/releases).
2. Extract.
3. Run `bin/scnr_activate KEY` to activate your installation -- if you haven't already done so for a previous release.
   1. [Acquire a license activation key](https://ecsypno.com/)  -- if you haven't already done so for a previous release.

You can now run Codename SCNR by using the executables under the `bin/` directory.

For a CLI scan you can run `bin/scnr URL`.

For more information please consult the [documentation](https://documentation.ecsypno.com/scnr/).

### Codename SCNR Pro (WebUI)

You can run Codename SCNR Pro by running `bin/scnr_pro`.

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

## Dependencies for headless environments or WSL

For minimal environments such as headless servers or the Windows Subsystem for Linux, please first run:

```
sudo apt-get update
sudo apt-get install libgconf-2-4 libatk1.0-0 libatk-bridge2.0-0 libgdk-pixbuf2.0-0 libgtk-3-0 libgbm-dev libnss3-dev libxss-dev libasound2
```

## License

Copyright 2023 [Ecsypno Single Member P.C.](https://ecsypno.com/).

All rights reserved.
