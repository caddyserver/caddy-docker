FROM alpine:3.15

RUN apk add --no-cache ca-certificates mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/2f23e8a67eba98613ba87f2d04768f6b28875386/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/2f23e8a67eba98613ba87f2d04768f6b28875386/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.5.0

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='9acd4fb788ed19bfe0718e67b23f259d8af3715e87670fce63667aebdc615351eac438066d617a8869da1dcf44cb643694dd479212065b2b79a5ccb52d667ae6' ;; \
		armhf)   binArch='armv6'; checksum='af1f44c727849ac65a7d842de5f3f8c12e09d0c05f02a84c298e360ea0d0b285927bf1c5a3df6e9eb5f328b576fee6742a0357bd4a8d4cf329e7d624d630b93c' ;; \
		armv7)   binArch='armv7'; checksum='a5ad120205237d1a2914dba5670c7ffd930fdfd3523bd2779616995bf7a6560de76a4b6e32a1c557cf9217f6cb802299f46ad076c4718d00fdb4b21c8ff55647' ;; \
		aarch64) binArch='arm64'; checksum='37be9629eae6dadd257c5beaf32102564b77d7b8c8d97aac5a2bc8e93962a55afe25fa315f36a5f132665cb4124e9f33c0f5d8a253c60a994bc44d20a4428381' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='53dfd99f56ee682f88a4d631d3e8b34bad91ca51af39298bb07bab9290d66d6a4c2557e5103a1600a875cfa928be44febc88544ae0d42692d6c9a9479ab8479e' ;; \
		s390x)   binArch='s390x'; checksum='b65614c618d3a9e8200389c2434291556283ffc39b834523893c75b2a335e7253bf8a571b310e2a4c60e24141fd32a5e66d0774434f443002753331b42ec3737' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.5.0/caddy_2.5.0_linux_${binArch}.tar.gz"; \
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

LABEL org.opencontainers.image.version=v2.5.0
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
