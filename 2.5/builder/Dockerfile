FROM golang:1.18-alpine

RUN apk add --no-cache \
    git \
    ca-certificates

ENV XCADDY_VERSION v0.3.0
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.5.1
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='2e4903c04f1918710566d5bca2b7b7ed6e8319aa925275040a9d9af87198cbc202b1f76b8ce0282f4423da9afb8634a14b59dd420879a188d024c5cbcf32b771' ;; \
		armhf)   binArch='armv6'; checksum='93648db05fabddb8b284d952895be26700908bcd3d3a4102529dc8ca9365c11e942672b9b19b64a4ed0b08880410b388f4c89276bf83e5dd77a7c4c5049c1619' ;; \
		armv7)   binArch='armv7'; checksum='ada8f06d71c088e8f6cf872c427710ae236a44cb8f18c4b0ba58663f49db8beb7a5caee18d0b23bd67a8db94fd839e5273ff9cd1b928576b4748072279cfb335' ;; \
		aarch64) binArch='arm64'; checksum='33421b53b12d642f2439321cd6bb6b72e93a5585601febad051b461cfe5cac09a983ce8b2f60bc8b045ee2a583e53ce1d595123f14f4bf6ea07c5c4da07b6465' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='bcd738433a37d5f5a47ed668ae517adbef5cb3aa406d1e449d6ea7eb077de4c85bfb199490929d97fb3c5d1edef40d49d1a7f080f8972e5a606f783362facb24' ;; \
		s390x)   binArch='s390x'; checksum='bbeb8f6e6f9dadb306e4d73f85ada7cc2c2e1d3e29ef6db16b19bef915681c83f145bf96cd9ac2f1c4d551b7a25be5c9b9c642b59136ecdb08d77b2a3a081f37' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.3.0/xcaddy_0.3.0_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
