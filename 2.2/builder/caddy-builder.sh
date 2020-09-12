#!/bin/sh
set -eu

cat > main.go <<EOF
package main

import (
	caddycmd "github.com/caddyserver/caddy/v2/cmd"
	_ "github.com/caddyserver/caddy/v2/modules/standard"
EOF

for p; do
    pkg=$(echo $p | cut -f1 -d@)
    cat >> main.go <<EOF
    _ "${p%%@*}"
EOF
done

cat >> main.go <<EOF
)

func main() {
	caddycmd.Main()
}
EOF

cat > go.mod <<EOF
module caddy

require (
	github.com/caddyserver/caddy/v2 $CADDY_SOURCE_VERSION
)

replace github.com/caddyserver/caddy/v2 => /src/caddy
EOF

set -x
export CGO_ENABLED=0
go get "$@"
go build -trimpath -tags netgo -ldflags '-extldflags "-static" -s -w' -o /usr/bin/caddy
/usr/bin/caddy version
