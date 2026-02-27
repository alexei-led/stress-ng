# syntax=docker/dockerfile:1

# ── Stage 1: build cg-inject ─────────────────────────────────────────────────
# cg-inject is a pure-stdlib Go binary that joins a target container's cgroup
# before exec-ing stress-ng, enabling same-cgroup stress testing (Pumba's
# --inject-cgroup mode). CGO disabled; result is a fully static binary.
FROM golang:1.23-alpine AS cg-inject-builder
WORKDIR /src
COPY go.mod ./
COPY cmd/cg-inject/ ./cmd/cg-inject/
RUN CGO_ENABLED=0 GOOS=linux go build \
        -ldflags="-s -w" \
        -trimpath \
        -o /cg-inject \
        ./cmd/cg-inject/

# ── Stage 2: final scratch image ─────────────────────────────────────────────
# stress-ng is compiled on the CI runner (native, with all build deps) and
# copied in at build time via --build-context or plain COPY.
# cg-inject is copied from the builder stage above.
FROM scratch
COPY --from=cg-inject-builder /cg-inject /cg-inject
# hadolint ignore=DL3010
COPY stress-ng /stress-ng
# Default entrypoint is stress-ng for direct use.
# Pumba's --inject-cgroup mode overrides ENTRYPOINT to /cg-inject.
ENTRYPOINT ["/stress-ng"]
