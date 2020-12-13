FROM alpine:3.12

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
ENV CADDY_VERSION v2.3.0-rc.1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='92df67a441431c809e2fc060d820b6919f8fab4b2073a9fb025b51bbb122b2784a814c80ba79683d8ec5742daae70d27867f623ef2579afc6d0ca9e5649223c6' ;; \
		armhf)   binArch='armv6'; checksum='05596a277c9642fed15066ad42d2c2fb2d65eda92ac2303df95807c0a3a6532ddf7dd88e7f4d20de5fdfa259ec76098176c8033562d7b6e06ed7592019c5a4ad' ;; \
		armv7)   binArch='armv7'; checksum='9605b8c0a45396c7a4ed85b4bb85c9a3f24b4374e6625d14bcbf73a8a8930a6609c19807fbb2e40ce154cd633a117c5f9a7952dc5e12c885f06f60106c28c659' ;; \
		aarch64) binArch='arm64'; checksum='51b5b6f824ef247d6cd007aeb05ceab4a02bc1ff40c2773d8c246ecafd4a992dc6f84acd63f58f6c5adecd7f0c757cc2425b6efe1c3e2c4b56bc0231c55135db' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='5bf72bc947d3ed262c4362774253cbbc6bb66c3a3dd0da99133a36ffc38760efd6c132a92e3b779563bef62249751bdf95fa4f99478e8bd2317c2aa437de2cb1' ;; \
		s390x)   binArch='s390x'; checksum='5f271a23114b94a7a56bd9bb7e239b913c1b98de124687b24051ee0acd2d83e2eb000108e0e4060e8ecfb1abc74ba321dfb1eac0c9108be3ac1b7b100d38cf36' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.3.0-rc.1/caddy_2.3.0-rc.1_linux_${binArch}.tar.gz"; \
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

LABEL org.opencontainers.image.version=v2.3.0-rc.1
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
