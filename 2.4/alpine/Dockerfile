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
ENV CADDY_VERSION v2.4.0-beta.1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='8472074e11c81292a9fc1764783c64fdc9e5909fb0711bac9544f2aac9e215757a6f42e081cd56c3be9fac7a4a7879e497b6112a7c9c5e0f43ae52f42984e9b9' ;; \
		armhf)   binArch='armv6'; checksum='a947bc69e50420d99ffb5540371990db5d9800f83114ece15c72169a415d0b08c07d25ff9eb76099cd666dc9ca9dfe6662948b7a936f43cec9533c5b9bf4e91a' ;; \
		armv7)   binArch='armv7'; checksum='d7b102fae8aa3b9928c55751a41d92cc0d122ca0e5e1204429ce7c2685049eba16dbb268198a791244cd3919581b7648c78aad8518d6d22f483f0bf5a323af19' ;; \
		aarch64) binArch='arm64'; checksum='2e06d91729bf47d92362d7882f4e39aa896cf2d6bcb95bcab5751a51d58bf9b80fea3e2fad6c666a3a3c0e2b327c15ffc86827b13afd971868450bf1aac5d737' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='a0c2a1dce40059cb6951b7ab861364d2c6857e6b1cc85816f4717886cb9f2be659b18a4a469888c1cb47160e5122188458ba819a69da979b561f12db8e8ff256' ;; \
		s390x)   binArch='s390x'; checksum='d9b0c3bfbfbc5d2e8724494b5a7b7f435c6543425b27eb26c3220a0452f8e3c1e992523ec8b11f71e7751c3a45eafb193872bc154ca8e187bae8e9c26ee94b3e' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.4.0-beta.1/caddy_2.4.0-beta.1_linux_${binArch}.tar.gz"; \
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

LABEL org.opencontainers.image.version=v2.4.0-beta.1
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
