FROM alpine:3.13

RUN apk add --no-cache ca-certificates mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/e784a6dd41d1cd4f72de2a427961bfb097b72cf9/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/e784a6dd41d1cd4f72de2a427961bfb097b72cf9/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.4.0-rc.1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='c5b1f2f25e9551817e80084edada0deeaa75a133d693d9bf1e6d667f9bf42fab2338e65a2b564d41c8bdf2841fae4b0f0a4fe204aa30f7ab80dec65a662ee8f6' ;; \
		armhf)   binArch='armv6'; checksum='805f7d0d4e9735e7670fac81e822d7801708f1ea0303f17c1fe4a1d05fdcdf9b3eaea65fb53812717bea6925fd6f5cab194722762a0f70c25645cfa08fc0a395' ;; \
		armv7)   binArch='armv7'; checksum='6adebb5be8f31b7f563967abe54dd5fac28a6aad80d863a6d24781213eabba31e08cdb5c0a25ddbdcdd76cdb7b0b4b26e82acc2ebe7fdad4c209b3de382408cf' ;; \
		aarch64) binArch='arm64'; checksum='17829b719112fdda07e716bfb740cef6bf1163735305bce9c01a94699e9fbaf0a7ce16f0981b49fa06b9fa11101837448ab183bd0095b739c39d056f0f77bd83' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='45e0ac82b829d164ab63cb344e8e2582678820a28953de9f1018b1343bd5d993bbe042fe9b57ed74652110a46463e2ae6b70c3437838dc2fa781baf9f0c037ba' ;; \
		s390x)   binArch='s390x'; checksum='f143ba8439c0c400094f20b4c49f6e57fc6356052e3a00ae5292f68d15a9f55ff1d1ad7394fa5453ad893ef480ca0f828ad957b29feb168628f84c28c2eb9377' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.4.0-rc.1/caddy_2.4.0-rc.1_linux_${binArch}.tar.gz"; \
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

LABEL org.opencontainers.image.version=v2.4.0-rc.1
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
