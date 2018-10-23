# stress-ng
[![Docker Build Statu](https://img.shields.io/docker/build/alexeiled/stress-ng.svg)]() [![Docker Pulls](https://img.shields.io/docker/pulls/alexeiled/stress-ng.svg)]() [![Docker Stars](https://img.shields.io/docker/stars/alexeiled/stress-ng.svg)]() [![ImageLayers Size](https://img.shields.io/imagelayers/image-size/alexeiled/stress-ng/latest.svg)]() [![ImageLayers Layers](https://img.shields.io/imagelayers/layers/alexeiled/stress-ng/latest.svg)]()

## Info

`stress-ng` Docker image is a `scratch` image that contains statically linked `stress-ng` tool only.

## Usage

Read the official `stress-ng` [documentation](http://kernel.ubuntu.com/~cking/stress-ng/).

```sh
# run for 60 seconds with 4 cpu stressors, 2 io stressors and 1 vm stressor using 1GB of virtual memory
docker run -it --rm alexeiled/stress-ng --cpu 4 --io 2 --vm 1 --vm-bytes 1G --timeout 60s --metrics-brief
```
