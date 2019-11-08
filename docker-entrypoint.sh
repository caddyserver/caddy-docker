#!/usr/bin/env sh

set -eu

caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
