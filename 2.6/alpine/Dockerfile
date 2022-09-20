FROM alpine:3.16

RUN apk add --no-cache ca-certificates mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/8c5fc6fc265c5d8557f17a18b778c398a2c6f27b/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/8c5fc6fc265c5d8557f17a18b778c398a2c6f27b/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.6.0

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='c05515dd332aa2ef1d50ff7285118deb31aabed336efb8234aaaafe531d0a4525488deffdccd50a20bb9688d4df15464a7d3642956975942528b1705f7811b08' ;; \
		armhf)   binArch='armv6'; checksum='e40d557c5c36ae5fe956e1906c3e967f925daf115347188c19b47b118dc7d2c967e8caa8e8a7604a5474114d33552611c85b9135b0ea2c08045635dc6c2a0316' ;; \
		armv7)   binArch='armv7'; checksum='6ce633b30541767f93fb1115ab34448d6275856e3dc9fcc31a7ea0472f322838057d23274116181bb15558caac41ddeab89f156880143769485f0b6870afecdb' ;; \
		aarch64) binArch='arm64'; checksum='6c7aed21dceec7532ec39c4fa79ba7df6e15cfb9c8802244893de8c6b1998eef79a54810bed271e962c5546be482d6dcc20cbeb9773d23920abbf75694afcbe1' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='abd734031a318d69296e0e8776b62267466cbdbc994079db4d9615d15ce79a2369a58317a6d812fe0979bcfe447b15dc5a53f1bad97e9e9b2b4af69a331da17d' ;; \
		s390x)   binArch='s390x'; checksum='b727ba39563709f5f53f026e96e6361d0649b9bb7a151f5ecb46b4c1652664516999c708d65b96366b87730ced97b826256fad2ac04db171be893dde815388be' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.6.0/caddy_2.6.0_linux_${binArch}.tar.gz"; \
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

LABEL org.opencontainers.image.version=v2.6.0
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
