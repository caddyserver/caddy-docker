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
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION=v2.11.0-beta.1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='9441ece956da83b0cdc035a5a0a60c555adf7dfbffe5e9af2d35441d1569e27d556903322ae0f1a26395a3d5751c7de11e3a4372f094f24c4f857ef25c9e64a1' ;; \
		armhf)   binArch='armv6'; checksum='26cdba5283da5ebc7ed8357a7c3e5f5848c6712fa16687178f8cb0c550d34d84e42a88252415a7a05bc4d13435c55426f65e3e5c04567445b0af1373f74cb75c' ;; \
		armv7)   binArch='armv7'; checksum='e28777002768621fe56d64aa78e37a93e97247d585b20f87b9c32225d4ca263639d9c8d3e9fc1097b417717f90ad84041ef82d5bf92d2317c3519b83a69080a8' ;; \
		aarch64) binArch='arm64'; checksum='7e6d8e6e13ef9ae63ce14c9f70a5e02460d7e465c62c9d402be25dc4ec1724fb98c75eb31def4b1c5fb8c823a607996c95e0cb5c4a4c0575f75ff81b6bfabe32' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='2c41117e105c6930b0d9b86ab72f3e7bfd3c25c94ece7aec8943ff8449aa7394e731a8e877516478efc8d99260802e4f8d1f6dab63af0f3aba0df3ce43f97d0d' ;; \
		riscv64) binArch='riscv64'; checksum='3cddd524e87420fff6f8d93167315786824d6175eff375b5f9d708dd03a0bc07adf276f474c82729f729e083b77bf9c02d91b62a898d1def4723ad6acfea1c09' ;; \
		s390x)   binArch='s390x'; checksum='0efba93666c06348e79e57f56ce3f9c7c1a8c51fd5c8f57c95f413d7a2243db905959b62d475477120877b8c59e950a11cea68ddbfd0421c6adbbf458ab3914d' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.11.0-beta.1/caddy_2.11.0-beta.1_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

LABEL org.opencontainers.image.version=v2.11.0-beta.1
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
