FROM golang:1.13.6-alpine

WORKDIR /src

RUN apk add --no-cache \
    git \
    ca-certificates

ONBUILD COPY . .
ONBUILD RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -tags netgo -ldflags '-extldflags "-static" -s -w' -o /usr/bin/caddy
