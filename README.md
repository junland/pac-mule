# pac-mule 
[![Build Status](https://travis-ci.org/junland/pac-mule.svg?branch=master)](https://travis-ci.org/junland/pac-mule)

Simple server written in Go that issues a proxy auto configuration file to clients.

## Prerequisites

`go` - 1.8.x or higher

`upx` - For binary compression if your going to use the `Makefile` (Optional)

## Installing from Source

1. `git clone https://github.com/junland/pac-mule.git`

2. `cd pac-mule`

3. `make binary`

4. `mkdir /etc/pac-mule && touch /etc/pac-mule/pac.js` (Edit the `pac.js` file with your proxy config.)

5. `sudo ./pac-mule start`

6. Go to your browser and type in `http://localhost:8080/config` to get your proxy config!

## Environment Variables

`MULE_LOG_LEVEL`  - Specifies log level in STDOUT. (Default: `INFO`)

`MULE_SRV_PORT` - Specifies server port number. (Default: `8080`)

`MULE_PAC_FILE` - Specifies location of PAC (Proxy Auto Config) file. (Default: `/etc/pac-mule/pac.js`)

`MULE_TLS` - Specifies if server should be a TLS server (Default: `false`)

`MULE_CERT` - Specifies location of TLS certificate. (No default.)

`MULE_KEY` - Specifies location of TLS key. (No default.)

## Built With

* [sirupsen/logrus](https://github.com/sirupsen/logrus) - Structured, pluggable logging for Go.

## Versioning

I use [SemVer 2.0.0](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/junland/pak-mule/tags).

## Authors

* **John Unland** - *Initial work* - [junland](https://github.com/junland)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project

## License

This project is licensed under the GPLv2 License - see the [LICENSE](LICENSE.md) file for details
