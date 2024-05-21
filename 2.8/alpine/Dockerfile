FROM alpine:3.19

RUN apk add --no-cache \
	ca-certificates \
	libcap \
	mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/509c30cecd3cbc4012f6b1cc88d8f3f000fb06e4/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/509c30cecd3cbc4012f6b1cc88d8f3f000fb06e4/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.8.0-rc.1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='7d5d17be995506566d1441bf5e35dc546992616be32d82eeddc88d8f28e1f76321da5775063e64293ba367b83d7698f4698f68c940e8bd3c4fbe9978a9eeee70' ;; \
		armhf)   binArch='armv6'; checksum='ca4bc32c88c0019ee7b8fa593e19c4f33ff245db1364dcda38e71a14c17167119f26f18f65aa2afc064aa2f80c2e1dfe9feb4da08ecd6b212290a59d40bf4760' ;; \
		armv7)   binArch='armv7'; checksum='c3efc0fe4875dbf91b31657022c20c5fd4fae888edddbdcda85e69289ab795f47287a01d0680d4b13085b23ea0eca8511745922f1323c5875555e13d7bf4417a' ;; \
		aarch64) binArch='arm64'; checksum='b682faa859efb7959d44e721bde3684d4ed5701f9880afd40b40feda3f525e6ebaf5c5900e9c33f8ffc202d6e79ff30735333678cd62cb5a6d27e894ec25d108' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='6680923022e1c4d081733fc39e5193072d7093c2b1726663c12f2f323b5bd4cc94b2af844a69228c9228019f88faa7c52aa29dfc758346b7e0020e267dac6db6' ;; \
		s390x)   binArch='s390x'; checksum='9b7ffd94ef5fef8f5892097d5ca82dcb9757ce28ffa2407ce310e9a72d8ecb746ca08da5f9a5d4fba5a11b3d81eeaab4f9cd199fc503ec78ae6c9fa4adb1b8cd' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.8.0-rc.1/caddy_2.8.0-rc.1_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

LABEL org.opencontainers.image.version=v2.8.0-rc.1
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
