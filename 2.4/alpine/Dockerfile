FROM alpine:3.13

RUN apk add --no-cache ca-certificates mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/56302336e0bb7c8c5dff34cbcb1d833791478226/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/56302336e0bb7c8c5dff34cbcb1d833791478226/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.4.0-beta.2

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='41daeac683d503264496689c6271645293c95518c5b97870c3f3a17127ae35b820622720315901c0c5856b42e0201b7eaad153dfa4a1045502a99f41d0b9785d' ;; \
		armhf)   binArch='armv6'; checksum='51e4d7220064e1948232c8c54996b012d01fe0e2caa71200e34f0da59bd6267cdc318124e1a7a44e83ce54b7276f6d0fb32381d3080e05902d3c3528ff423dd7' ;; \
		armv7)   binArch='armv7'; checksum='9c3b4eea4840a1fe633d45d436789edf6839e96527783d2eac309d24e5085c0cdee8beffd7e5ad2f1d7d31e16004e916aa29456d8ac52007e9d904e644d6db40' ;; \
		aarch64) binArch='arm64'; checksum='86cf83d11aee266d32c262982df3e286aa0a4b391fc4fbded0e299ace043c753e9a1f53bef1f95a292a71107e1f9578a8615b038871eedb171437eebe7db47d2' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='81b050dae2892feb517db6c782acc506dfe21399b0a79073e5191656f57c6d0a5a511caf1086ffc671712ab198715cca6a2a120812a4df8d774ba17d6242aa39' ;; \
		s390x)   binArch='s390x'; checksum='763256d267ad8832c37fa1a902fc06dfb6b9871b75e38545cbc199b50251f78b0cc2400104d31fc18d2c98408f02a74e581a7f7746974837dcdef51a4a259bf2' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.4.0-beta.2/caddy_2.4.0-beta.2_linux_${binArch}.tar.gz"; \
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

LABEL org.opencontainers.image.version=v2.4.0-beta.2
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
