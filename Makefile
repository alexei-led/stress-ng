.PHONY: test lint fmt build clean help

BINARY       := cg-inject
MODULE       := ./cmd/cg-inject/
GOFLAGS      := CGO_ENABLED=0
BUILD_FLAGS  := -ldflags="-s -w" -trimpath

## help: Show this help message
help:
	@grep -E '^##' $(MAKEFILE_LIST) | sed 's/## //'

## test: Run unit tests with race detector
test:
	go test -v -race -coverprofile=coverage.out $(MODULE)
	@go tool cover -func=coverage.out | tail -1

## lint: Run golangci-lint
lint:
	golangci-lint run --timeout=3m ./...

## fmt: Format Go code
fmt:
	gofmt -w -s .
	goimports -w .

## build: Build cg-inject binary (Linux static)
build:
	$(GOFLAGS) go build $(BUILD_FLAGS) -o $(BINARY) $(MODULE)

## clean: Remove build artifacts
clean:
	rm -f $(BINARY) coverage.out
