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
ENV CADDY_VERSION v2.2.0-rc.1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='e7bf7836e00fbddde6e853615db691d21a76d820d05039b48db040efe0ac5001b96d5ac01d60018fb7def0d15a139d68f1236496f6c78812e59e415a9d768b89' ;; \
		armhf)   binArch='armv6'; checksum='be0e8936cd2ff9a7d415c99e39be9bde62b280ec8d66042f83006720312182ee19bb5d1e99abbe5a8166dd67b8c9431c1fe58376b7f649a971310455dc6c6cee' ;; \
		armv7)   binArch='armv7'; checksum='3d11d77fff3a4e9076cba3be2cf1cca9c0a91c98bf320921ba7f81150c62a63c3d3ba77e4d4e8883edae871c7e32395910613f1972cf91397541860db2b1b021' ;; \
		aarch64) binArch='arm64'; checksum='bea4de59d39cc15a60aee11e437346cfed02c755f274313939702c3c19c360ae8d6cb21bd013bfc8388be63f435e844535c4746dd13db7dc9146591d2f4743e9' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='44f036fc5e89a4efc2e94540f302f6734d535a5e7100858251d108dbaa827e0f1eb88f3de28854d0c155f3398550c0a2f82802648ce7b8d33b9d9d01632db155' ;; \
		s390x)   binArch='s390x'; checksum='84eb431373a13fb90da3c373b1c39b45e1ce399bb67758f29adf5814da37b7bd0afb954549e4565e8d5ee02b52c674c26d46b11af90e7c8e90df7496cfc5ae08' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.2.0-rc.1/caddy_2.2.0-rc.1_linux_${binArch}.tar.gz"; \
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

LABEL org.opencontainers.image.version=v2.2.0-rc.1
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
