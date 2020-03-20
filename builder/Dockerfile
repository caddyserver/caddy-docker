FROM golang:1.14.1-alpine3.11 AS builder

WORKDIR /src

RUN apk add --no-cache \
    git \
    ca-certificates

ENV CADDY_SOURCE_VERSION=v2.0.0-beta.17

RUN git clone -b $CADDY_SOURCE_VERSION https://github.com/caddyserver/caddy.git --single-branch

WORKDIR /src/caddy/cmd/caddy

RUN go get ./...

COPY caddy-builder.sh /usr/bin/caddy-builder
