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
ENV CADDY_VERSION v2.2.0

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='8fb18c1ade5df35c1b2c709ccad45b4893d7c713303446bf05fae22508e69a3c0c0cd354f6c8995262d8e65e08cdf64b5d43a13361ecf1514197081a21b83641' ;; \
		armhf)   binArch='armv6'; checksum='79b9162b689ca8e24c6cefad8894262f040d972bef1a3712f94b10f1e405ced58c8b1f6706d8338cf2d8f152cc62f773f12a61614aa88a48d9a4fbea0f40fd3c' ;; \
		armv7)   binArch='armv7'; checksum='ec01f438ab2f7e4afaa32da2685cdeeed8cc84d9e03518e713a841101569dad58ae5b66209f871b5adf959d63d19722ba7fcefbe4f583a2d6651feb6dbc65d5c' ;; \
		aarch64) binArch='arm64'; checksum='64d63caed8909fa5b13c4e9c50ed2a9a6fe1e2da30b960c08ce995081475d0d7d53bdf5b6c67209f900bdcc49ce5680c61fcf68b2c1e89331a7c68f035659f58' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='f4f80cac0df5ecad18f9ee88139c83e6a0eef4518c7dbe3dcf4152fad20be368ed7fd31d5d1930b31cd5f99405c6d67977738ae03dcb33c8f723d9663f876d42' ;; \
		s390x)   binArch='s390x'; checksum='04713e3b99e659652504767fdc7908cf38567cdfa7a3fa8557be57c6d438dfefe1cd28d778f7bba95f8c1db5d45f78dc32effd14d03a2a09dd2c5f464e757c82' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.2.0/caddy_2.2.0_linux_${binArch}.tar.gz"; \
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

LABEL org.opencontainers.image.version=v2.2.0
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
