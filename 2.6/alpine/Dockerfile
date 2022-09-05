FROM alpine:3.16

RUN apk add --no-cache ca-certificates mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/v2.6.0-beta.3/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/v2.6.0-beta.3/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.6.0-beta.3

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='4fd35ccbf42ace902e1fa196b7cb52bfbd9eb49907b10e46a256072516336a78de23b0bbd548efc8254693b73862ee1705aeb1696cacfc6452f8faed62d60e65' ;; \
		armhf)   binArch='armv6'; checksum='357f1053c87327631c8f8b66e19b662a9feb3d3cd85346ca726ac64b4cb6005781b7af4c1c23eadfd8a6099d3dc50eb375e8caf3227072f24f42ac1e15647d5e' ;; \
		armv7)   binArch='armv7'; checksum='26fe73813a6897424d4d2c584644c3bd96e6e57a63b3d4643edb3bd33f75bb6e8de8f6c5378c00dd19f562e54966afe55bcf58a2ba77ac5aa4c58b6006a65a51' ;; \
		aarch64) binArch='arm64'; checksum='0637a726186c6ff15988e1a528a5b680b60d23c016e68e7f52224b556d92825e228bf9fa4e4d0be48ce23344a7b186016f9119a6fb4686747c525c80837713eb' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='8b2c8d8e5f80dc441bb1189966be70510bfd6147867e0a8e61c5afb5be85e054f7e7e453894fa0f7fd33f18d73ee1f85b175d548e7c09e9733d096b5c3281ed7' ;; \
		s390x)   binArch='s390x'; checksum='fbaf777d888e96ce7061c5f8e3fa399086ba3dcf1656d2ab365ee275857f9853d9586ca3f90698b8bf3a2dc098891266db0301d2d6f15dba036a288d035e3ac2' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.6.0-beta.3/caddy_2.6.0-beta.3_linux_${binArch}.tar.gz"; \
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

LABEL org.opencontainers.image.version=v2.6.0-beta.3
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
