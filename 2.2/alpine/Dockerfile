FROM alpine:3.12

RUN apk add --no-cache ca-certificates mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/506330b23c5cce43a9352179e7977a684678fbaf/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/506330b23c5cce43a9352179e7977a684678fbaf/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.2.0-rc.3

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='05ca569f22d55e61b75f7813b9d9cf0b8a3d9d0308cd1cc7d89463b0e97f864bbbb00386103d88cea323099310a55f12407e7547b32631a0c41e850cc3188159' ;; \
		armhf)   binArch='armv6'; checksum='9e7ae77cfbc0e36651011afe59273b533e7bc8e2514aad98d3ee0c4a301cca82fe89b19d98d291de34ce0e07d1c2e4a57709fb386cb687ec83e609cbfaf84d7d' ;; \
		armv7)   binArch='armv7'; checksum='8310eb2b18ec9afe5aab5d64f7b8dc04fcdac15106b6e3a767d4081ad3ed184de6981f87eb184c80d4ff49e9067ee36b9b6703eb400509003c6de6a2ed8588f3' ;; \
		aarch64) binArch='arm64'; checksum='717c289c53fcaa6ed33cea8975fc4350fa95e61e3c703a82771c9cc9b1951572c996c5823ea9cc6ad2e2cecb841bea6dc51a8fb0f95fbdef8dbb70620e6b39e4' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='2c96c8e83da29be72617d4a8fa2f9eb747974bbf5129f27a4a8a5ec7b5b0ef73a315652435cd0c097e27ffa4aff1ed2b31e6d7ee791aa113214582aa69f1a1a7' ;; \
		s390x)   binArch='s390x'; checksum='6306428655b66cd53ad274a42b4c572109ee5a2c9cff0ad0bdb9912174089de94222dfa1ed0b5ea3fe5ff7bfe970fc884a0222325684b4214ff64a9e168979f9' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.2.0-rc.3/caddy_2.2.0-rc.3_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	chmod +x /usr/bin/caddy; \
	caddy version

# set up nsswitch.conf for Go's "netgo" implementation
# - https://github.com/docker-library/golang/blob/1eb096131592bcbc90aa3b97471811c798a93573/1.14/alpine3.12/Dockerfile#L9
RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

VOLUME /config
VOLUME /data

LABEL org.opencontainers.image.version=v2.2.0-rc.3
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

WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
