FROM debian:jessie as builder

# intall gcc and supporting packages
RUN apt-get update && apt-get install -yq make gcc

WORKDIR /code

# download stress-ng sources
ARG STRESS_VER
ENV STRESS_VER ${STRESS_VER:-0.08.17}
ADD https://github.com/ColinIanKing/stress-ng/archive/V${STRESS_VER}.tar.gz .
RUN tar -xf V${STRESS_VER}.tar.gz && mv stress-ng-${STRESS_VER} stress-ng

# make static version
WORKDIR /code/stress-ng
RUN STATIC=1 make

# Final image
FROM alpine:3.6

COPY --from=builder /code/stress-ng/stress-ng /usr/local/bin

ENTRYPOINT ["/usr/local/bin/stress-ng"]