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

#### Setup

If this is a fresh installation, you can setup a DB with:

    ./bin/scnr_pro_task db:create db:migrate db:seed

#### Update

If you'd like to update an existing installation you can do it with:

    ./bin/scnr_pro_task db:migrate

## License

Copyright [Ecsypno](https://ecsypno.com/). 
All rights reserved.
