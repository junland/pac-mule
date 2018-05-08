PWD:=$(shell pwd)
GOPATH:=$(shell go env GOPATH)
GIT_COMMIT:=$(shell git rev-parse --verify HEAD --short=7)
VERSION?=0.0.0
BIN_NAME=pac-mule

.PHONY: clean
clean:
	@echo "Cleaning..."
	rm -rf ./$(BIN_NAME)
	rm -rf ./*.tar.gz
	rm -rf ./*.deb
	rm -rf ./*.rpm
	rm -rf ./*.pem
	rm -rf ./obj-*
	@echo "Done cleaning..."

.PHONY: fmt
fmt:
	@echo "Running $@"
	go fmt *.go

tls-certs: clean
	@echo "  ################ WARNING #################  "
	@echo "  # Do not use these CERTs for production. #  "
	@echo "  ##########################################  "
	@echo "Making Development TLS Certificates..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem -subj "/C=US/ST=Texas/L=Austin/O=Local Development/OU=IT Department/CN=127.0.0.1"

binary: clean
	@echo "Building binary for commit $(GIT_COMMIT)"
	go build -ldflags="-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION) -s -w" -o $(BIN_NAME)

binary-upx: clean
	@echo "Building compressed binary for commit $(GIT_COMMIT)"
	go build -ldflags="-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION) -s -w" -o $(BIN_NAME)
	upx -9 -q ./$(BIN_NAME)

binary-debug: clean
	@echo "Building debug binary for commit $(GIT_COMMIT)"
	go build -ldflags="-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION)" -o $(BIN_NAME)

binary-upx-debug: clean
	@echo "Building compressed debug binary for commit $(GIT_COMMIT)"
	go build -ldflags="-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION)" -o $(BIN_NAME)
	upx -9 -q ./$(BIN_NAME)

releases: clean
	@echo "##########################################################################"
	@echo "Building and packing version $(VERSION) binaries for commit $(GIT_COMMIT)."
	@echo "##########################################################################"
	$(MAKE) amd64-binary
	tar cvf $(BIN_NAME)-v$(VERSION)-amd64.tar.gz $(BIN_NAME) README.md LICENSE docs/
	$(MAKE) aarch64-binary
	tar cvf $(BIN_NAME)-v$(VERSION)-aarch64.tar.gz $(BIN_NAME) README.md LICENSE docs/
	$(MAKE) armhf-binary
	tar cvf $(BIN_NAME)-v$(VERSION)-armhf.tar.gz $(BIN_NAME) README.md LICENSE docs/

amd64-binary:
	rm -f $(BIN_NAME)
	GOARCH=amd64 go build -ldflags "-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION) -s -w" -o $(BIN_NAME)

aarch64-binary:
	rm -f $(BIN_NAME)
	GOARCH=arm64 go build -ldflags "-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION) -s -w" -o $(BIN_NAME)

armhf-binary:
	rm -f $(BIN_NAME)
	GOARCH=arm GOARM=7 go build -ldflags "-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION) -s -w" -o $(BIN_NAME)
