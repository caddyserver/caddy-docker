#!/bin/sh
set -eu

args=""
for p; do
	args="$args --with $p"
done

/usr/bin/xcaddy build $CADDY_SOURCE_VERSION --output /usr/bin/caddy $args