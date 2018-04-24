PWD:=$(shell pwd)
GOPATH:=$(shell go env GOPATH)
GIT_COMMIT:=$(shell git rev-parse --verify HEAD --short=7)
VERSION?=0.0.0
TRAVIS_TAG?=$(VERSION)
BIN_NAME=pac-mule

.PHONY: clean
clean:
	@echo "Cleaning..."
	rm -rf ./pac-*
	rm -rf ./*.deb
	@echo "Done cleaning..."

.PHONY: fmt
fmt:
	@echo "Running $@"
	go fmt *.go

tls-certs:
	@echo "  ################ WARNING #################  "
	@echo "  # Do not use these CERTs for production. #  "
	@echo "  ##########################################  "
	@echo "Making Development TLS Certificates..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem -subj "/C=US/ST=Texas/L=Austin/O=Local Development/OU=IT Department/CN=127.0.0.1"

binary:
	rm -rf ./pac-*
	@echo "Building binary for commit $(GIT_COMMIT)"
	go build -ldflags="-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION) -s -w" -o $(BIN_NAME)

binary-upx:
	rm -rf ./pac-*
	@echo "Building compressed binary for commit $(GIT_COMMIT)"
	go build -ldflags="-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION) -s -w" -o $(BIN_NAME)
	upx -9 -q ./$(BIN_NAME)

binary-debug:
	rm -rf ./pac-*
	@echo "Building debug binary for commit $(GIT_COMMIT)"
	go build -ldflags="-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION)" -o $(BIN_NAME)

binary-upx-debug:
	rm -rf ./pac-*
	@echo "Building compressed debug binary for commit $(GIT_COMMIT)"
	go build -ldflags="-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION)" -o $(BIN_NAME)
	upx -9 -q ./$(BIN_NAME)

releases: 
	@echo "Building binaries for commit $(GIT_COMMIT) for version $(VERSION)"
	$(MAKE) -C amd64-binary
	tar cvf $(BIN_NAME)-v$(VERSION)-amd64.tar.gz $(BIN_NAME) README.md
	$(MAKE) -C aarch64-binary
	tar cvf $(BIN_NAME)-v$(VERSION)-aarch64.tar.gz $(BIN_NAME) README.md
	$(MAKE) -C armhf-binary
	tar cvf $(BIN_NAME)-v$(VERSION)-armhf.tar.gz $(BIN_NAME) README.md

amd64-binary:
	rm $(BIN_NAME)
	GOARCH=amd64 go build -ldflags "-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION) -s -w" -o $(BIN_NAME)

aarch64-binary:
	rm $(BIN_NAME)
	GOARCH=arm64 go build -ldflags "-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION) -s -w" -o $(BIN_NAME)

armhf-binary:
	rm $(BIN_NAME)
	GOARCH=arm GOARM=7 go build -ldflags "-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION) -s -w" -o $(BIN_NAME)
	
