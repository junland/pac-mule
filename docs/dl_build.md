# Download and build

## System requirements

Running pac-mule can run on almost all hardware (amd64, armhf, aarch64 etc.), however pac-mule has been written with Linux / Unix in mind so the only supported operating system would be Linux / Unix.

## Download pre-build binary from releases

You can grab a pre compiled binary in the [releases](https://github.com/junland/pac-mule/releases) section of this repository which is is the fastest way to get this software.

## Building binary from source

### Prerequisites

`go` - 1.8.x or higher, with `GOPATH` set up.

`make` - For using the `Makefile`.

`upx` - For binary compression if your going to use the `Makefile` (Optional).

Once your prerequisites have been installed follow these steps:

1. `git clone https://github.com/junland/pac-mule.git`

2. `cd pac-mule`

3. `make binary`

These steps should produce a binary called `pac-mule` which you can execute from your current shell.

## Verifying the binary

To verify that your downloaded or built binary executes correct is to issue this command:

```
./pac-mule version
```

This should display version text of the compiled binary.
