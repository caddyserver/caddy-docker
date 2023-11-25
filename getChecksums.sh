#!/usr/bin/env bash
#
# A script that outputs a mapping of arch to checksum for a given release.
#
# Usage:
#   ./getChecksums.sh repo version
#
# Example:
#   ./getChecksums.sh caddy 2.7.5
#
# repo can be either caddy or xcaddy, and version should be the raw semver,
# without a leading 'v'
# 

REPO=$1
VERSION=$2
# Parse semver
SEMVER_RE='[^0-9]*\([0-9]*\)[.]\([0-9]*\)[.]\([0-9]*\)\([0-9A-Za-z\.-]*\)'
VERSION_MAJOR=`echo ${VERSION} | sed -e "s#$SEMVER_RE#\1#"`
VERSION_MINOR=`echo ${VERSION} | sed -e "s#$SEMVER_RE#\2#"`
VERSION_PATCH=`echo ${VERSION} | sed -e "s#$SEMVER_RE#\3#"`
VERSION_SPECIAL=`echo ${VERSION} | sed -e "s#$SEMVER_RE#\4#"`

# Get the checksums file from the tagged release
curl -sSL -o checksums.txt https://github.com/caddyserver/${REPO}/releases/download/v${VERSION}/${REPO}_${VERSION}_checksums.txt

# architecture keys
arches=(
  amd64
  arm32v6
  arm32v7
  arm64v8
  ppc64le
  s390x
  windows_amd64
)

# archives suffixes as they appear in the checksums file
archive_names=(
  linux_amd64.tar.gz
  linux_armv6.tar.gz
  linux_armv7.tar.gz
  linux_arm64.tar.gz
  linux_ppc64le.tar.gz
  linux_s390x.tar.gz
  windows_amd64.zip
)

# Get the last index for the loop
last=$(expr "${#arches[@]}" - 1)

echo "{"
for i in $(seq 0 $last); do
  # Grab the current arch from the list
  arch="${arches[i]}"

  # Get the checksum of the archive for this arch
  checksum=$(awk "/${archive_names[i]}/{print \$1}" checksums.txt)

  # Skip if we don't have the checksum
  [ -z "${checksum}" ] && continue

  if [ $i -lt $last ]; then
    echo "    \"${arch}\": \"${checksum}\","
  else
    echo "    \"${arch}\": \"${checksum}\""
  fi
done
echo "}"
