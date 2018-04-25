# pac-mule 
[![Build Status](https://travis-ci.org/junland/pac-mule.svg?branch=master)](https://travis-ci.org/junland/pac-mule)

Simple server written in Go that issues a proxy auto configuration file to clients.

## Getting pac-mule

The easist way to get pac-mule is to grab a pre-compiled binary in the [releases](https://github.com/junland/pac-mule/releases) section of this repository

If you want build from source please follow [this][download_build] documentation. 

## Running pac-mule

To start a basic instance of pac-mule you can fill in the needed paramters and run this command:

```
MULE_PAC_FILE=<PAC FILE> ./pac-mule start
```

Now clients can get the config from `http://localhost:8080/config`

You can also launch a more secure instance of pac-mule by generating a SSL certificate and key. Doing this you can run this command:

```
MULE_PAC_FILE=<PAC FILE> MULE_TLS=true MULE_PORT=443 MULE_CERT=<SSL CERT FILE> MULE_KEY=<SSL KEY FILE> ./pac-mule start
```

Now clients can get the config from `https://localhost/config`

## Built With

* [sirupsen/logrus](https://github.com/sirupsen/logrus) - Structured, pluggable logging for Go.

## Versioning

I use [SemVer 2.0.0](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/junland/pak-mule/tags).

## Authors

* **John Unland** - *Initial work* - [junland](https://github.com/junland)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project

## License

This project is licensed under the GPLv2 License - see the [LICENSE](LICENSE.md) file for details.

[download_build]: docs/dl_build.md
