FROM alpine:3.13

RUN apk add --no-cache ca-certificates mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/a8ef04588bf34a9523b76794d601c6e9cb8e31d3/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/a8ef04588bf34a9523b76794d601c6e9cb8e31d3/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.4.4

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='49fbc425dff4c366389c3fb35e624b1dde5748df3aae54120fbc1511d5136b58828fbf8ec0207aa9ca0d1bbf841be8c2760eaa3890ac5101b9c220b221de7393' ;; \
		armhf)   binArch='armv6'; checksum='dada00f6d2ed3b946309d0b500c869d0f994b81b402bf3b112cfb54caa67592f01fc432c9c737aecbf9ae7af179fd93efb8e91ca6066d747d8c42e48d2ad514f' ;; \
		armv7)   binArch='armv7'; checksum='25deed88c52b91d7d3f70cb46dfe5c3a458f1705673111feb519f63c28ac9c3adc4f93711736a317557c2ec10c2f78779154c4d56a3d4c1f838982893ba8346e' ;; \
		aarch64) binArch='arm64'; checksum='421ccd38b28356b06e05c45af975bbd3e8ee28590a6ce599a1d7fd82f660fb7dc47d05b6f1ee1a6535232669d27f04144ab4f65f565d0307674b8389977f2b7d' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='2d3724ecb56f77f2622a0240a6ba481f208913e9f1c85f2d60bd21da6f62d8dbeaef2cfd601ba956d7a4154b924652dd4151bdacab519c623927726e8701d201' ;; \
		s390x)   binArch='s390x'; checksum='2c8a6465cf1c6e1ebd0b8c8a83e09d0dcb0ccaa0470d4a8df59267e26b7ec66e4b3f0ea3c86fef5de57e09401a0fb022794c12ddf14a996f95512abbe4b9d54b' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.4.4/caddy_2.4.4_linux_${binArch}.tar.gz"; \
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

LABEL org.opencontainers.image.version=v2.4.4
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
