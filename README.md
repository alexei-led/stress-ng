# stress-ng

[![](https://badge.imagelayers.io/alexeiled/stress-ng:latest.svg)](https://imagelayers.io/?images=alexeiled/stress-ng:latest) [![Docker badge](https://img.shields.io/docker/pulls/alexeiled/stress-ng.svg)](https://hub.docker.com/r/alexeiled/stress-ng/)


## Usage

Read the official `stress-ng` [documentation](http://kernel.ubuntu.com/~cking/stress-ng/).

```sh
# run for 60 seconds with 4 cpu stressors, 2 io stressors and 1 vm stressor using 1GB of virtual memory
docker run -it --rm alexeiled/stress-ng --cpu 4 --io 2 --vm 1 --vm-bytes 1G --timeout 60s --metrics-brief
```