FROM alexeiled/stress-ng as stress-ng

FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y cgroup-bin wget docker.io && \
    rm -rf /var/lib/apt/lists/* 

RUN wget -O /usr/local/sbin/dockhack https://raw.githubusercontent.com/alexei-led/dockhack/master/dockhack && \
    chmod +x /usr/local/sbin/dockhack

COPY --from=stress-ng /stress-ng /bin/stress-ng