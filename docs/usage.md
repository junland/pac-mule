# Usage of pac-mule

This document describes commands, flags, and enviroment variables for pac-mule.

## Commands

`start` - Starts a server serving a proxy auto configuration file.

`version` - Displays the current version.

## Flags

`-h --help` - Displays the help screen.

## Environment Variables

`MULE_LOG_LEVEL`  - Specifies log level in STDOUT. (Default: `INFO`)

`MULE_SRV_PORT` - Specifies server port number. (Default: `8080`)

`MULE_PAC_FILE` - Specifies location of PAC (Proxy Auto Config) file. (Default: `/etc/pac-mule/pac.js`)

`MULE_TLS` - Specifies if server should be a TLS server using `true` or `false` (Default: `false`)

`MULE_CERT` - Specifies location of TLS certificate. (No default.)

`MULE_KEY` - Specifies location of TLS key. (No default.)
