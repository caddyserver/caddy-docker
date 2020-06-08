FROM golang:1.14-alpine3.12 AS builder

WORKDIR /src

RUN apk add --no-cache \
    git \
    ca-certificates

ENV CADDY_SOURCE_VERSION=v2.1.0-beta.1

RUN git clone -b $CADDY_SOURCE_VERSION https://github.com/caddyserver/caddy.git --single-branch

WORKDIR /src/caddy/cmd/caddy

RUN go get -d ./...

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /src/custom-caddy/cmd/caddy
