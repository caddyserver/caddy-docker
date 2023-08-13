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
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/5910351159c2995a9a1c911d7879de6ff598d905/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/5910351159c2995a9a1c911d7879de6ff598d905/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.7.3

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='ae7a367be45f5cdaa9e5fd082e225dd84f291a6fb1fe2fefa05b9958461e0967d02de23c9147c8e8ebdc4c91b352e887c1c95b06a64fde6be69a5a32fc459d5e' ;; \
		armhf)   binArch='armv6'; checksum='d6744a5e835b08208f5bfcd17525ace7b77420bca575126831f0c27100bc2b5f1ce5dcc08585e90bc8e45261d1bacd2ee37d0b1ac7bd57525e953f2a383f2820' ;; \
		armv7)   binArch='armv7'; checksum='eed7a8e99dd0802b195986e077a0607536680fc22d735bde2a2773becdd2ab1063754940264dc0f1c1ca81d8d8647e0924a16aead067f1c73c5c372de9320e5c' ;; \
		aarch64) binArch='arm64'; checksum='258429b3e7fe821c132f4d455a69c2d230a3f90d18bfebdbf7e9676099e7c6dc1a12af7e0b526b8f6b044cb10fe2aab12e449e529e5ed316b7e5b8433e1b353a' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='af49e94af887ef9090ff664877fdb462f33a129f6565504d7cc4b6e3c2995dd4b1b831338809b2450edfea292defa05711beb7cae35331995117258650e17de1' ;; \
		s390x)   binArch='s390x'; checksum='81a2bd1e27bf1793c1979009973b468bfc4d05486888ad0376f0e425ef28812e3149f1f7f60dc924d914af6e8ee7ac90c7e1a9c8dd20c2c370f7063c3fa5049a' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.7.3/caddy_2.7.3_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

LABEL org.opencontainers.image.version=v2.7.3
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
