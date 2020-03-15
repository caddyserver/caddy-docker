FROM alpine:3.11.3

RUN apk add --no-cache ca-certificates

# https://github.com/caddyserver/dist/commits
ENV CADDY_DIST_COMMIT 80870b227ded910971ecace4a0c136bf0ef46342

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/$CADDY_DIST_COMMIT/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/$CADDY_DIST_COMMIT/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.0.0-beta.15
ENV CADDY_CHECKSUM_SHA256 80ddcf00d54e7c5d10211847c30846df460635aaaa5c4e64aafa01ce2e8ee48d
# TODO: alter filename after v2 relese (version will be taken out of name)
RUN set -eux; \
	wget -O /usr/bin/caddy "https://github.com/caddyserver/caddy/releases/download/$CADDY_VERSION/caddy2_beta15_linux_amd64"; \
	echo "$CADDY_CHECKSUM_SHA256 caddy2_beta15_linux_amd64" | sha256sum -c; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_DATA_HOME=/data
ENV XDG_CONFIG_HOME=/config

VOLUME /config/caddy
VOLUME /data/caddy

LABEL org.opencontainers.image.version=v2.0.0-beta.15
LABEL org.opencontainers.image.title=Caddy
LABEL org.opencontainers.image.description="a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go"
LABEL org.opencontainers.image.url=https://caddyserver.com
LABEL org.opencontainers.image.documentation=https://caddyserver.com/docs
LABEL org.opencontainers.image.vendor="Light Code Labs"
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.source="https://github.com/caddyserver/caddy-docker"

EXPOSE 80
EXPOSE 443
EXPOSE 2019

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
