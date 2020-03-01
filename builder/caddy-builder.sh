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
    pkg=$(echo $p | cut -f1 -d@)
    echo -e "\t_ \"$pkg\"" >> main.go
done

cat >> main.go <<EOF
)

func main() {
	caddycmd.Main()
}
EOF

# We only want x.y, not x.y.z
gover=$(echo $GOLANG_VERSION | awk -F. '{ print $1"."$2 }')

cat >> go.mod <<EOF
module caddy

go $gover

require (
	github.com/caddyserver/caddy/v2 $CADDY_SOURCE_VERSION
)

replace github.com/caddyserver/caddy/v2 => /src/caddy
EOF

for p in $plugins; do
    go get $p
done

CGO_ENABLED=0 go build -trimpath -tags netgo -ldflags '-extldflags "-static" -s -w' -o /usr/bin/caddy
