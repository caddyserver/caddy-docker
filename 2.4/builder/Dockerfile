FROM golang:1.16-alpine3.13

RUN apk add --no-cache \
    git \
    ca-certificates

ENV XCADDY_VERSION v0.1.9
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.4.1
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='dd5b347105df354edca8a77679bdf63e848de39cebcb8c1be3c2a38db16d1e8aee0e4ee84c1164333d15fa62b4491e4190f74efdff3d4f043a38d5e0c0eb3663' ;; \
		armhf)   binArch='armv6'; checksum='5d21cdbf7875c9fe37dfd5a0480b94ce03c815e49fc9c2a8abebda5b4af47ebd58a60e5b9b95fd520a13d4da36d9cd74b9a5cb5dbdaf763366d594f731c46c00' ;; \
		armv7)   binArch='armv7'; checksum='3a6a4441685e17be4b067b627d15892ef380dbfb23184b6b413468f78f1d7aae7ca540d35029490aadbad75ea9573cbb58ac7081bd518c1cbe9791dccdf92cd3' ;; \
		aarch64) binArch='arm64'; checksum='b9946f6e105fe800394e371ad32212f1a6cc78b5cd187b1a146226f3635c245a924819cc66c36c84b6ffe230d339d1b3ede9bb0a71f94134f580a6dd01df411f' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='635888995efed987ebd2ebfa44e1bbba0f9901c2ce9897c5f97b769ba063339a1cc4055157c5ddc79121b8c79dabb6d6067b6df3ccaa49a3c4bd4f957bc3ac5b' ;; \
		s390x)   binArch='s390x'; checksum='aa78736d3c600b34ccba4e2ef69475d62992282e2003a5586cbf9b66a1e16624cf48d2dab005dca5591cb2c6ffc2a39e3c847ea332f0f679b68d6d00520e143b' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.1.9/xcaddy_0.1.9_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
