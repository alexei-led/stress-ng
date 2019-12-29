# stress-ng
[![](https://github.com/alexei-led/stress-ng/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/alexei-led/stress-ng/actions?query=workflow%3A"Docker+Image+CI") [![](https://github.com/alexei-led/stress-ng/workflows/Check%20stress-ng%20Release/badge.svg)](https://github.com/alexei-led/stress-ng/actions?query=workflow%3A"Check+stress-ng+Release")
[![Docker Pulls](https://img.shields.io/docker/pulls/alexeiled/stress-ng.svg)]() [![Docker Stars](https://img.shields.io/docker/stars/alexeiled/stress-ng.svg)]()

## Info

`stress-ng` Docker image is a `scratch` image that contains statically linked `stress-ng` tool only.

## Auto update

This image is automatically rebuilt, using GitHub actions, once a new version of `stress-ng` tool is released.

## Usage

Read the official `stress-ng` [documentation](http://kernel.ubuntu.com/~cking/stress-ng/).

```sh
# run for 60 seconds with 4 cpu stressors, 2 io stressors and 1 vm stressor using 1GB of virtual memory
docker run -it --rm alexeiled/stress-ng --cpu 4 --io 2 --vm 1 --vm-bytes 1G --timeout 60s --metrics-brief
```
