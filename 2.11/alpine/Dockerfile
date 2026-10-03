FROM alpine:3.24

RUN apk add --no-cache \
	ca-certificates \
	curl \
	libcap \
	mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	chmod 1777 /config/caddy /data/caddy; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION=v2.11.7

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='a7a433a1b133efc3c8d10eb0b99d52a24b5ef5c322dc77f5282182b1c0402139ab83f3a99f0c52409df77d20123fb0b523edad8a66d8f5e49136197bf61ef0e7' ;; \
		armhf)   binArch='armv6'; checksum='139d7eb079be6b9fcdb2b707424e3c0c4f20f522c4f156fd27fdd05d6eaebf8c8f966104d24adfc3a5b8982626cebbec84f1c3c1b7a68edb1693e64e9708c22b' ;; \
		armv7)   binArch='armv7'; checksum='6eb3894f9a215f75f3ec50e627c34b2cd6fb81d10ec7838f27c30dcf417b810f618136b507766bc17e7400a5c0f4fa6001bb062ebb7a401ee63505012615825e' ;; \
		aarch64) binArch='arm64'; checksum='3db36ba90c7a6e8dda40ee3dd71fa08844c76b5fb08f61b31e5e78d2ed38e71c51dc7baed875e50d1ca1279196e84302967237386ae87c91ae9f2aaceada682e' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='1d7ca41bbcfa14048cf07f1fc5215ff7d85afb61d7f2b34e4d5b72fd3047bf3fcfb4721a4da35f640cdd949ac5ce6844a2e4371939fad6100d8c537ea15a3d55' ;; \
		riscv64) binArch='riscv64'; checksum='f72d9be744675c3566f5a17a6d4b1c56e6e20d1e190b06f6f5332223048ac1c73222dc8b4b941bd8afc915f1442727c81dc19176bbcb5bfae81cb47680ae98b4' ;; \
		s390x)   binArch='s390x'; checksum='dff058c9cadbdd9ab56b545900bc02327c39f54b0075707ee500755be26d416eaf8361033c929db679cd71c1687d337905047f95d3e0cd183006661778aedc3d' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.11.7/caddy_2.11.7_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

LABEL org.opencontainers.image.version=v2.11.7
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
