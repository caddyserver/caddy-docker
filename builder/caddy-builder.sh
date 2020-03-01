#!/bin/sh
plugins=$@

mkdir -p /src/custom-caddy/cmd/caddy
cd /src/custom-caddy/cmd/caddy

cat >> main.go <<EOF
package main

import (
	caddycmd "github.com/caddyserver/caddy/v2/cmd"
	_ "github.com/caddyserver/caddy/v2/modules/standard"
EOF

for p in $plugins; do
    echo -e "\t_ \"$p\"" >> main.go
done

cat >> main.go <<EOF
)

func main() {
	caddycmd.Main()
}
EOF

cat >> go.mod <<EOF
module caddy

go 1.14

require (
	github.com/caddyserver/caddy/v2 $CADDY_SOURCE_VERSION
)
EOF

CGO_ENABLED=0 go build -trimpath -tags netgo -ldflags '-extldflags "-static" -s -w' -o /usr/bin/caddy
