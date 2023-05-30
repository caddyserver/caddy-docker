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
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/305fe484cc8a9ac72900e8cc172d652102a87240/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/305fe484cc8a9ac72900e8cc172d652102a87240/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.7.0-beta.1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='613addc729beb06a05c29f8fc5be9b02fecab506c70bbe091d0c212829ce72e7005e0649d037086e600c9c337dd6a18fc0df661b10ce6bc97b577a4a12228705' ;; \
		armhf)   binArch='armv6'; checksum='4a603e908f6101a2847c6580118b2dc6b8ee0a7d479fd70bc5497405dad67a5250a7c88f05e7a19dd0995b37dcb7a2e27de18de71b3d56b48ed0e494f9c99445' ;; \
		armv7)   binArch='armv7'; checksum='72ec1ac7f1405f7e514af35525b4fbf77fb966f06124b7f7f2445d979ba6f491eee28bf2b51f995303b5fb3a0ce01e1d9e41199d2b72b5613e53be9006a77326' ;; \
		aarch64) binArch='arm64'; checksum='89a296d0ca4f6d0c7e8584582414f6aa254427e25705839e315d18b1256d96549ef124bea2dddee3cbcee0202cfb646c34b2aec07918adb273c397588409eadb' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='22eb564de9e53451800f4617db03af29c5843ed3c34570c8ff50ffb232a9b47d40e199f54490fab12dea8f78c77c009d4b585228b029514228e42cfbba321fa4' ;; \
		s390x)   binArch='s390x'; checksum='9d0be7a10cc64869055174a808957e8eea8be781c6e1a903c5fe295ca15bc17298f8a06d219801d839ae6089290160f8dccd485e94fb40f42c65ca591e85117b' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.7.0-beta.1/caddy_2.7.0-beta.1_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_admin,cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

LABEL org.opencontainers.image.version=v2.7.0-beta.1
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
