PWD:=$(shell pwd)
GOPATH:=$(shell go env GOPATH)
GIT_COMMIT:=$(shell git rev-parse --verify HEAD --short=7)
GO_VERSION:=$(shell go version | grep -o "go1\.[0-9|\.]*")
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
	rm -rf pac-mule
	rm -rf pac-mule-*
	@echo "Done cleaning..."

.PHONY: fmt
fmt:
	@echo "Running $@"
	go fmt ./...

tls-certs: clean
	@echo "  ################ WARNING #################  "
	@echo "  # Do not use these CERTs for production. #  "
	@echo "  ##########################################  "
	@echo "Making Development TLS Certificates..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout key.pem -out cert.pem -subj "/C=US/ST=Texas/L=Austin/O=Local Development/OU=IT Department/CN=127.0.0.1"

binary: clean
	@echo "Building binary for commit $(GIT_COMMIT)"
	go build -ldflags="-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION) -X github.com/junland/pac-mule/cmd.GoVersion=$(GO_VERSION)" -o $(BIN_NAME)

.PHONY: travis-sizes
travis-sizes: clean fmt
	@echo "Building unstripped binary..."
	@go build -o pac-mule-default || (echo "Failed to build binary: $$?"; exit 1)
	@echo "Size of unstripped binary: $$(ls -l pac-mule-default | awk '{print $$5}') bytes or $$(ls -lh pac-mule-default | awk '{print $$5}')" > ./size-report.txt
	@echo "Building stripped binary..."
	@go build -ldflags="-s -w" -o pac-mule-stripped || (echo "Failed to build stripped binary: $$?"; exit 1)
	@echo "Size of stripped binary: $$(ls -l pac-mule-stripped | awk '{print $$5}') bytes or $$(ls -lh pac-mule-stripped | awk '{print $$5}')" >> ./size-report.txt
	@echo "Compressing stripped binary..."
	@cp ./pac-mule-stripped ./pac-mule-compressed
	@upx -9 -q ./pac-mule-compressed > /dev/null || (echo "Failed to compress stripped binary: $$?"; exit 1)
	@echo "Size of compressed stripped binary: $$(ls -l pac-mule-compressed | awk '{print $$5}') bytes or $$(ls -lh pac-mule-compressed | awk '{print $$5}')" >> ./size-report.txt
	@echo "Building binary with gccgo..."
	@go build -compiler gccgo -o pac-mule-gccgo
	@echo "Size of binary using gccgo: $$(ls -l pac-mule-gccgo | awk '{print $$5}') bytes or $$(ls -lh pac-mule-gccgo | awk '{print $$5}')" >> ./size-report.txt
	@echo "Reported binary sizes for Go version $$(echo -n $$(go version) | grep -o '1\.[0-9|\.]*'): "
	@cat ./size-report.txt
	@rm -f ./*.txt

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
	GOARCH=amd64 go build -ldflags "-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION) -X github.com/junland/pac-mule/cmd.GoVersion=$(GO_VERSION)" -o $(BIN_NAME)

aarch64-binary:
	rm -f $(BIN_NAME)
	GOARCH=arm64 go build -ldflags "-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION) -X github.com/junland/pac-mule/cmd.GoVersion=$(GO_VERSION)" -o $(BIN_NAME)

armhf-binary:
	rm -f $(BIN_NAME)
	GOARCH=arm GOARM=7 go build -ldflags "-X github.com/junland/pac-mule/cmd.BinVersion=$(VERSION) -X github.com/junland/pac-mule/cmd.GoVersion=$(GO_VERSION)" -o $(BIN_NAME)
