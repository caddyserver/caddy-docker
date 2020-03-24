FROM alpine:3.11

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
ENV CADDY_VERSION v2.0.0-beta.19
ENV CADDY_CHECKSUM_SHA256 8e44c8f801fd01f544738767af4ea76359dca17718d1aafcfa893ea45a837736
# TODO: alter filename after v2 release (version will be taken out of name)
RUN set -eux; \
	wget -O /usr/bin/caddy "https://github.com/caddyserver/caddy/releases/download/$CADDY_VERSION/caddy2_beta19_linux_amd64"; \
	echo "$CADDY_CHECKSUM_SHA256  /usr/bin/caddy" | sha256sum -c; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

VOLUME /config
VOLUME /data

LABEL org.opencontainers.image.version=v2.0.0-beta.19
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
