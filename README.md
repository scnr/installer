# SCNR Installer

Installation instructions for [SCNR](https://ecsypno.com/scnr-documentation/) on
Mac OS X (Intel), Debian-based, RedHat-based or SuSE Linux distributions.

## Automated installation

To install run the following command in a terminal of your choice:

```bash
bash -c "$(curl -sSL https://raw.githubusercontent.com/scnr/installer/main/install.sh)"
```

It will also install:
* Linux
  * [Google Chrome](https://www.google.com/chrome/)
    * To resolve its dependencies for the _Engine_.
* OS X
  * [curl](https://curl.se/) -- For the _Engine_.

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

## License

Copyright [Ecsypno](https://ecsypno.com/). 
All rights reserved.
