FROM alpine:3.20

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
ENV CADDY_VERSION v2.8.0

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='90d7f2325f9f6feec22c2c84fb1bdad2e94ae08b227d3c44eaa6b82ce1ff5a31fedc047d95e4a0ec2df4c1cebf3426cf6003c9f1d665ba3e67093bc12b89606a' ;; \
		armhf)   binArch='armv6'; checksum='93a0467fe0945dfc12e86a22b161a8d230b9bd728db39293fae32175b438e04726d6a4f8d432b42db4fb48bae10227e0b1a714667f636f669c707e7996671724' ;; \
		armv7)   binArch='armv7'; checksum='98a7a06cf1202c6bc484907d255c1afd5302a38a6ed15a0fccebb1be861bceab2f496ffacc796a144e637dbac4f0de4494eb53952e5a8e37532e19aa58c6679a' ;; \
		aarch64) binArch='arm64'; checksum='37e6b62ebf76cac029204cd906dba72fd68ed302079dd4828efc2ade7aed746d8fc4aa301ceb8d1fbe277973247df563c8fa51d815c4c2e8f18f88cfefc1c40a' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='6156c44046e4e0b892c6ff79af387d86f96c0f1a2306f4496ba2b00f03d195e40f805c8f2c95a4f05293cbf283de23285ed94cea7eaeae1c4f910295a6c78c07' ;; \
		s390x)   binArch='s390x'; checksum='e9199812aba23ed037d2d2cc75f01a9a9c583a31bcc2b7ef336b646548e3e460a78a606397ed61c570b8ba5e352bf44affafd3eb9d66656f31d2263ac8275ca1' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.8.0/caddy_2.8.0_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

LABEL org.opencontainers.image.version=v2.8.0
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
