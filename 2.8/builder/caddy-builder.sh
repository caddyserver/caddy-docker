#!/bin/sh
set -eu

args=""
for p; do
	args="$args --with $p"
done

echo "Warning: the caddy-builder script is deprecated and will be removed in the future.
Instead, you should use the xcaddy command:

    xcaddy build $args
" >&2

# version is inferred from $CADDY_VERSION (set in the Dockerfile)
# output will be placed in the working dir (/usr/bin as set in the Dockerfile)
xcaddy build $args
