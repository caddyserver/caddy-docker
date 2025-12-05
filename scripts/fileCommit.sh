#!/usr/bin/env bash
set -Eeuo pipefail

# get the most recent commit which modified any of "$@"
git log -1 --format='format:%H' HEAD -- "$@"
