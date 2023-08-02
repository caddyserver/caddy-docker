FROM alpine:3.18

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
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/5910351159c2995a9a1c911d7879de6ff598d905/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/5910351159c2995a9a1c911d7879de6ff598d905/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.7.0

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='259a689456857baf8f7665ea36bac8a63c9a64c5cdc0a51d07ee660ae62fe61f2270c574084234c87898d1e6dfa36ec68d054e6082c757eaa0521ff2f3d63421' ;; \
		armhf)   binArch='armv6'; checksum='2f2606b488bdcd55033eae38715936e2f11fecd49e565ced767a4a409bd056c01846c112cece55d2edd013d8b017d053ba1ae20646a3d55b329547ae670e1232' ;; \
		armv7)   binArch='armv7'; checksum='7569ead2e2d7e39ab2fb79da2534462ef2f36e810b7d5e4fb0e08a9f60cd14dc3dd9fcf8e4d98ae39198884dd2f100c6a4b3e428d6e14925c2e3b62ca71b9045' ;; \
		aarch64) binArch='arm64'; checksum='311e17ac9b339c41edfefaf8d665f85ff54989bc3c5cd1fdd199455d79a967fcafa8daefce70c17cc835cdae2335a132d3c62a0b45b74b62541c143567690722' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='f272cd0d7d13071f6f969aee0d779b5eb15232a093f1e14adba86870d5402ef2f8769b5bff5d664e707c97d923f5ffd111e2071fed2f8611c8ff8eadf0bd9722' ;; \
		s390x)   binArch='s390x'; checksum='1c43521a13d09b113c5bfa27cc15d788c993eee468811830932950b3d7a59d8833e5f0a6077a9f50421fe81b1d946a3e899cd97dd0f3c8202c51e525766ee9dd' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.7.0/caddy_2.7.0_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

LABEL org.opencontainers.image.version=v2.7.0
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
