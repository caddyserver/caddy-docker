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
ENV CADDY_VERSION v2.8.0-beta.2

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='22d7b288e71e934ecdf07f9555461eaa04bf6f98eaa5cf27b4e8b4f366edc0344078a85ef8f8a36741f6166c502f7d012bd109d067769ba88ec5bfbab4f024a2' ;; \
		armhf)   binArch='armv6'; checksum='379d8077999ab7a155f83c41795651e9fb4cb6a582aba09915eabed964be3f86ce3d09ac51e4de4671e98700477909b5d850185b26ff92f79aae02c4a1e23664' ;; \
		armv7)   binArch='armv7'; checksum='9c1f3a0ea5f61a1842d94700f27c70f61ea24a8a354fd26a736475132f39e7fc260eaba6e56cd3d843c536bd96fead43dbdcf324db97bd98bbd3fcd1c7913c31' ;; \
		aarch64) binArch='arm64'; checksum='48280905d42940ea23f136b71dc28d8a3037cbe3f8839613e9d020362e55008acd23ed970dc8adbf5f783c4c7c842ad550b9228f23d6fe18737fe61fb94f3bc7' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='3c05832568897d3e83c8cfbf243e93efa478510fef4c81b902e4c899a7390e3b8c353f73dfad510cc68975ad6c52b6f73b8a4f90c64e523c78f17bb9549c12f0' ;; \
		s390x)   binArch='s390x'; checksum='e773a4ee18fd0f88e569fcac5d87ac95789579d71fdfc725844b5499cd06373fd292c4924f327fe332f22a934cac9383e7f36ca5edfd358612124b40be6c8d0e' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.8.0-beta.2/caddy_2.8.0-beta.2_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

LABEL org.opencontainers.image.version=v2.8.0-beta.2
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
