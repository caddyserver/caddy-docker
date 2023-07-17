FROM alpine:3.18

RUN apk add --no-cache \
	ca-certificates \
	libcap \
	mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/305fe484cc8a9ac72900e8cc172d652102a87240/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/305fe484cc8a9ac72900e8cc172d652102a87240/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.7.0-beta.2

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='0f540623859001ecbd651bda4c74cd1f0c587bd60c156b8cdfaef686487e73123b654a423d0c4b3df5c57221cc656acd3afd0c9b11303d6a4bdc1d5086a90f3d' ;; \
		armhf)   binArch='armv6'; checksum='6dc8ce3bf8ad3237f521f67be396bb23c608cfae5ada33be823c72d26c666edcc6e7aa483ef32cff42d2fdb8c43552e52dece9badbdd64fff6d0c3cd4a313bab' ;; \
		armv7)   binArch='armv7'; checksum='37e5ce287ee14da54c4835343738b8d0e4a12395bce99a33c5b6df90723444ab7607348652765112cb924d0bc7db1ecad396c095ef98598e89fa60710e5f7512' ;; \
		aarch64) binArch='arm64'; checksum='cc07d50c582490350dc6249c88921364e4ad4d0508388089018d207da7d5ad5497ae811dc762bde0a7c00a823419037024b8c16de4297f2e255d74d784a2f39b' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='5f2cf61309ea67f613c1a92120270fc39e7513e120ebc8818e0e185b32a46b69f9c527bd09e145561c61e73db8f6c3b5c05ba9da9a6a9f1b4bd14765e246c80b' ;; \
		s390x)   binArch='s390x'; checksum='f4179b75dcc6b302d805291377a8772df8e3dc5ae5733d9aa9884db29a543d87cf4bfb097e59d8d6baf4255fdb96b508d47f6387267eb3273c5c6d60a1f6b906' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.7.0-beta.2/caddy_2.7.0-beta.2_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

LABEL org.opencontainers.image.version=v2.7.0-beta.2
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
