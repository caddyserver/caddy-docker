#!/bin/sh

# Check if Caddyfile config is passed via $CADDYFILE
if [[ "$CADDYFILE" ]]; then
    echo 'Storing $CADDYFILE variable to ./Caddyfile'
    printf "$CADDYFILE" > Caddyfile # echo doesn't preserve newlines
fi

# Running passed command
if [[ "$1" ]]; then
    exec $@
fi