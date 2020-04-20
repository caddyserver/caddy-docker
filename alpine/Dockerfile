FROM alpine:3.11

RUN apk add --no-cache ca-certificates mailcap

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
ENV CADDY_VERSION v2.0.0-rc.3

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='32735a963f946bf561ed2a540192c22ad19565be4bce4bc243c61beae9022ca15a54bf5ef8a5f2341bd3af16fd7b0e9f7832697687201a981a2ac52b0c18ca88' ;; \
		armhf)   binArch='armv6'; checksum='5f1485c4be4a050dc12a42d9cc6b0a215a27173eca0bd46c09a0e5ac941b863511f695ca1fad211fb7ebb21e516c549aa2b6d7bc7b11ce3f3729a6c632315937' ;; \
		armv7)   binArch='armv7'; checksum='f38d32e6c48f6eb889d7f7bca9ef18d953aeafe8f6ae5b37a657318890c806999dbf4161ac3f5ccb7c6b356ffbded61228e24e6b1ad5e76b3d694923c2483984' ;; \
		aarch64) binArch='arm64'; checksum='c4786c030121519ea988ad418878f29b90487357bb434f357955a5ac158460192b4da136fd6d08a2507521a2920412ffa294bf2d83c858c3d1e7fb02de1482a2' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.0.0-rc.3/caddy_2.0.0-rc.3_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

VOLUME /config
VOLUME /data

LABEL org.opencontainers.image.version=v2.0.0-rc.3
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
