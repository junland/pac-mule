PWD:=$(shell pwd)
GOPATH:=$(shell go env GOPATH)
GIT_COMMIT:=$(shell git rev-parse --verify HEAD --short=7)
VERSION?=0.0.0
TRAVIS_TAG?=$(VERSION)
DEB_ARCH?=any

clean:
	@echo "Cleaning..."
	rm -rf ./pac-*
	rm -rf ./*.deb
	@echo "Done cleaning..."

fmt:
	@echo "Running $@"
	go fmt *.go

tls-certs:
	@echo "  ################ WARNING #################  "
	@echo "  # Do not use these CERTs for production. #  "
	@echo "  ##########################################  "
	@echo "Making Development TLS Certificates..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem -subj "/C=US/ST=Texas/L=Austin/O=Local Development/OU=IT Department/CN=127.0.0.0"

binary:
	rm -rf ./pac-*
	@echo "Building binary for commit $(GIT_COMMIT)"
	go build -ldflags="-X main.BinVersion=$(VERSION) -s -w" -o pac-mule

binary-upx:
	rm -rf ./pac-*
	@echo "Building binary for commit $(GIT_COMMIT)"
	go build -ldflags="-X main.BinVersion=$(VERSION) -s -w" -o pac-mule
	upx -9 -q ./pak-mule
