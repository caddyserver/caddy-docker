FROM golang:1.15-alpine3.12

RUN apk add --no-cache \
    git \
    ca-certificates

ENV XCADDY_VERSION v0.1.5
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.2.1
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='66a21e0643fd2538ffe88ab93cb4a158b94873c1ce7494543a8355c8a3492d5fa43f4fa030dfc9e9833d15fe04f010063c61cb3f04ad5ac6bcff80396f928a08' ;; \
		armhf)   binArch='armv6'; checksum='7e358d452fe7bbc0cdcba8a800339e34bd6277f698909d1d7a3b2ebd722653899b9bff6b7e8b996e9f054356374537f9971c1d5aed95f117dcce6be08e80446e' ;; \
		armv7)   binArch='armv7'; checksum='ed847f91c9726ba4f25dbf9954ebe072c893f3eecfac3b83ee5c541fc762f88f59b4bd8aa35d54dd1ac043ca6e54235a197137529fe003792fdc3801a5100cd0' ;; \
		aarch64) binArch='arm64'; checksum='dfc7ef12feea26b13b818cac8492664662c24835db1f8b862500debfddd30b7399d3ccc18a52fc8cc62b82ddb4cc41f2810580c1727b6c22e27dd74724bfae96' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='3b38fcb4752be955e05156d2510825e93c7f83592a405d22f9ecd63cecd1d102b2aae4b50ce8586c035edd5d53075d4daeac986bc2cc1e2e1f41c6d9723066c5' ;; \
		s390x)   binArch='s390x'; checksum='ebd76de742d38556aa6a7c68c000d530f46989f3db712b486d4dbe653ca69c3ba2333d19337e85d63c619f5c410f1d22dc982d9cdb6ce5e1ed94dbf29ec15190' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.1.5/xcaddy_0.1.5_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
