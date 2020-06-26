FROM alpine:3.12

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
ENV CADDY_VERSION v2.1.0

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='17d425b20a6906adfa57fd98181b349a2de1a0ac3331ae5cc2858bef1a4d755d7eb0ed093e1bda256d00ecca5f950267bbb892d08f016f00606c5b21b72b51ee' ;; \
		armhf)   binArch='armv6'; checksum='4260a1063eaebbafbf66370c697008ffcc991fadb0bf16e0382e296b5750d2b923c6bffeaa25c263e7bd0b919c42416b91246afff2aa2df160e7f2ffa3eb22c5' ;; \
		armv7)   binArch='armv7'; checksum='54a65f92bcb0813ec0942611aec2dee3cbe2a15c580d6e44abaf23b85d3cba50740a655ea22a0984087b26b6002fb08c01da0d2c0c95341981c59da4a4fc6e75' ;; \
		aarch64) binArch='arm64'; checksum='c2ced633f0de9ae7ffcf7484f364d199e19a962e6224a183a293926e6fffbd24e873c83327b7be1dcd43318e62376b1462a955e393d1e2c7d264e22fc24b7dee' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='d7a3015fee2f36079729246a816fca4656b45d67d708bf7fab9bbfa5ae200e777e97f5c4962de1693699204f32bb578cf31609bc0b1e19190fe1b7caeb5b9018' ;; \
		s390x)   binArch='s390x'; checksum='5f0af31c7272dccf6ad2e206510e27980e03b5ac817014d5b90eb4f476b2897c752c0fd27aecfc6cdab2d410be6dfb926cda8f2f2da0b46b8cef5285d5dbc922' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.1.0/caddy_2.1.0_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	chmod +x /usr/bin/caddy; \
	caddy version

# set up nsswitch.conf for Go's "netgo" implementation
# - https://github.com/docker-library/golang/blob/1eb096131592bcbc90aa3b97471811c798a93573/1.14/alpine3.12/Dockerfile#L9
RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

VOLUME /config
VOLUME /data

LABEL org.opencontainers.image.version=v2.1.0
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
