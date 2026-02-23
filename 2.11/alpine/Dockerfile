FROM alpine:3.23

RUN apk add --no-cache \
	ca-certificates \
	curl \
	libcap \
	mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	chmod 1777 /config/caddy /data/caddy; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION=v2.11.1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='cd194db2a730db0dbb343e9b468725d6bc31d915d977ed3fc79ae88af83fd0ad259d3560976a28c51ec5d9fd23a79980e71763eda5239beb8232e5adfa0a9707' ;; \
		armhf)   binArch='armv6'; checksum='e1165b9375507781d9fec1d5a1ccb179b252911b40bfcb654d19dade298d12e7fc67ef494d2bd9ff99649b23540f666d35a41b9489c690317145130acbf400d1' ;; \
		armv7)   binArch='armv7'; checksum='7c2dbe9cdac73ba8a3de4ec551a594c4c645f819e8ce2cf55b12421cbd79402a9aa4b41c717812e71595077eba2da919de1eb7251daee55dfd5a5ae456555f38' ;; \
		aarch64) binArch='arm64'; checksum='d7b1edfa08eb5576d468b44d4c0ad2c5273ba27de4fc9dd0acc58e7a7c66bd3729cbf78a79f421377f26180ad13fbba323b37f471ce5daf9332c393cb649f348' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='c74b1fc8794370b4fe8145fc4355655be41e03bab52637bd1374d8e91bee697145abd0cf3aa52bfd4f2b6f72874e901f8e7d9516f3f2b22dded6d1e6dd07a429' ;; \
		riscv64) binArch='riscv64'; checksum='26340ad3b323eec3e62d1827a9f369b532a8b001423fa4d2f9b5aa9f5431c8327d0aa18bfc5b215c957016d80f4a4a5083fd6df6ede30a921835a5538f6baba3' ;; \
		s390x)   binArch='s390x'; checksum='f17945253167d26038524bda89c8bf0ddd05774fc8baf5a22da136b989dacf696a24710e84d8fe694802c8accf0b0dff383093be8dc61537ae0536689ba9c366' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.11.1/caddy_2.11.1_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

LABEL org.opencontainers.image.version=v2.11.1
LABEL org.opencontainers.image.title=Caddy
LABEL org.opencontainers.image.description="a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go"
LABEL org.opencontainers.image.url=https://caddyserver.com
LABEL org.opencontainers.image.documentation=https://caddyserver.com/docs
LABEL org.opencontainers.image.vendor="Light Code Labs"
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.source="https://github.com/caddyserver/caddy-docker"

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
