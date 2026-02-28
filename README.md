# stress-ng

[![CI](https://github.com/alexei-led/stress-ng/actions/workflows/ci.yaml/badge.svg)](https://github.com/alexei-led/stress-ng/actions/workflows/ci.yaml)
[![Build and Release](https://github.com/alexei-led/stress-ng/actions/workflows/build-release.yaml/badge.svg)](https://github.com/alexei-led/stress-ng/actions/workflows/build-release.yaml)

Minimal multi-arch (`linux/amd64`, `linux/arm64`) Docker image with a statically linked [stress-ng](https://github.com/ColinIanKing/stress-ng) binary. Built from `scratch` — nothing but the binary.

> **⚠️ DockerHub Deprecation:** The `alexeiled/stress-ng` DockerHub image is deprecated. Use `ghcr.io/alexei-led/stress-ng` instead.

## Pull

```bash
docker pull ghcr.io/alexei-led/stress-ng:latest
```

Or pin to a specific version:

```bash
docker pull ghcr.io/alexei-led/stress-ng:0.20.00
```

## Usage

```bash
# Run for 60 seconds with 4 CPU stressors, 2 IO stressors,
# and 1 VM stressor using 1GB of virtual memory
docker run --rm ghcr.io/alexei-led/stress-ng \
  --cpu 4 --io 2 --vm 1 --vm-bytes 1G --timeout 60s --metrics-brief
```

### Kubernetes

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: stress-ng
spec:
  containers:
    - name: stress-ng
      image: ghcr.io/alexei-led/stress-ng:latest
      args: ["--cpu", "2", "--timeout", "60s", "--metrics-brief"]
```

## Troubleshooting

### "stress-ng: error: [1] No stress workers"

This error occurs when you run the container **without specifying any stressors**. stress-ng requires at least one stressor type (CPU, memory, I/O, etc.) to run.

**Solution:** Always pass at least one argument. Examples:

```bash
# CPU stress only (default)
docker run --rm ghcr.io/alexei-led/stress-ng --cpu 2 --timeout 60s

# View all available options
docker run --rm ghcr.io/alexei-led/stress-ng --help

# Complex example: CPU + memory + I/O
docker run --rm ghcr.io/alexei-led/stress-ng \
  --cpu 4 --vm 2 --vm-bytes 512M --io 2 --timeout 120s --metrics-brief
```

## How It Works

- **No source code in this repo** — only the minimal build configuration.
- **Native Builds** — the binary is compiled natively on GitHub Actions runners (`ubuntu-24.04` for amd64, `ubuntu-24.04-arm` for arm64) for maximum speed and reliability.
- **Scratch Image** — the compiled binary is copied into a `scratch` image (0 dependencies, minimal size).
- **GitHub Container Registry** — images are pushed exclusively to `ghcr.io`.

## License

[GPL-2.0](LICENSE) (same as upstream stress-ng)
