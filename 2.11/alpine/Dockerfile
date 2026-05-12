FROM alpine:3.23

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
ENV CADDY_VERSION=v2.11.3

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='ee886eceda0ff9f30610d3be9b5b594026591e19add6b3961a341c72abe468e5eac9d7c2c2450bbb8420db1f827b954521f9336be4872f81090b8618adf8815a' ;; \
		armhf)   binArch='armv6'; checksum='84b3baef4f1850a8a75ab38f1da8c08eea5a19a9081ecb62af2658e7c9919203ef1907233e8b27b4dc4ddd6f0a8f57893d10190c611f15e2325ea9962f2073d5' ;; \
		armv7)   binArch='armv7'; checksum='7ae0bcf5a1060ac0bcb0c9d454f21f70b2655c2e883a3a1617069d12193eae650e4410807cc50e216b01775cb0e0c16ab84490a03454153d189cfe5775cf775c' ;; \
		aarch64) binArch='arm64'; checksum='bd06996e1612cf5e9770dc7134313067ef3fdfde43b1a2196004906006de779372dcf7a0e7c7fb0890c23791179f12be4625f1b6e666a2abf37e8aff4c3a1826' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='e1f33af0869f8234fc28575ee6eef04f7dfd0b3a6255be6efdc3aa3d05d05db833c4571e90287908eae93da1383e07e93ed9c6ad0199ccc0f1fe798cb88f43ce' ;; \
		riscv64) binArch='riscv64'; checksum='9b0f3f8ab8816d57878f251e7913d7622340dff9092770397db740ca5e9930b5718c67231c97ef6cd3ba886de57060fc01ca1ab018d9cac1d0878092312fd280' ;; \
		s390x)   binArch='s390x'; checksum='eb71dfa44b5ed5db32af566b6fa2e3f711df828b847c55f250ff8cfd9af22ab79048f3bc8d9756ac06683c54d46ba2e11c6b109fdda16c6a28c29a88f327d9e1' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.11.3/caddy_2.11.3_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

LABEL org.opencontainers.image.version=v2.11.3
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
