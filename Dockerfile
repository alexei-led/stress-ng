FROM debian:jessie as builder

# intall gcc and supporting packages
RUN apt-get update && apt-get install -yq make gcc

WORKDIR /code

# download stress-ng sources
ENV STRESS_VER=0.09.41
ADD https://github.com/ColinIanKing/stress-ng/archive/V${STRESS_VER}.tar.gz .
RUN tar -xf V${STRESS_VER}.tar.gz && mv stress-ng-${STRESS_VER} stress-ng

# make static version
WORKDIR /code/stress-ng
RUN STATIC=1 make

# Final image
FROM scratch

COPY --from=builder /code/stress-ng/stress-ng /

ENTRYPOINT ["/stress-ng"]
