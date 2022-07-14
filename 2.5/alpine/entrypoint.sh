#!/bin/sh

# Check if Caddyfile config is passed via $CADDYFILE
if [[ "$CADDYFILE" ]]; then
    echo 'Storing $CADDYFILE variable to /etc/caddy/Caddyfile'
    echo -e $CADDYFILE > /etc/caddy/Caddyfile
fi

# Running passed command
if [[ "$1" ]]; then
    eval "$@"
fi