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
ENV CADDY_VERSION=v2.11.6

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='422771007d505ea97efd1177a4905b2c1a471cd426668f2ace3bcda3d8e30b11f9b1610bfb02c6ad60f2a795f56124f2f5eec6409c17d5a0dd4c21a11375fb94' ;; \
		armhf)   binArch='armv6'; checksum='c120f071720e1b5581386e840dc7b78ddd5fbae12f36cbe01ee7f5af776e2fbc8b7f69e2731023efa1ed740aaf5309f66743f4be2fc386b8cea640c9ad6dd708' ;; \
		armv7)   binArch='armv7'; checksum='c9ed41fd5944604bc0ef184cdfbef47d9c2405869feadb1ae218d9c916a270e915c92aebcb98d6bcf49a5d66a3d47703103ee801d3d429a8694b086b975814d6' ;; \
		aarch64) binArch='arm64'; checksum='bd228ea44b6b95720a0c2d7b62886e99cb4a0b05356fe6e058c4a155618c913377b18e686839ae7fcc6c2c05aea2d549fa91f25aa3ef8d43cdead117259577ed' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='acc236010e39f5ec0ff973eee4d6bfce4efa6c3c5bbd1de357e85ecd0aa0468998a17980efbefe7643b8d1368c5bd85a555524b0c12c3ba3c16d5f527294b68c' ;; \
		riscv64) binArch='riscv64'; checksum='56afa5cff92dc9c99f138c2cb8557a83b9049d2e09cbb36023c77b9b71e913a9acd8e74e48a7ce482b21dc2aba8d6b373e94bb24e86717d3e720b1cd3d13379c' ;; \
		s390x)   binArch='s390x'; checksum='fd2db1d4f325102029ebc4b6ead4ddf669daf4efea2628dab7623b071a953f69b26806b441e6555494130d45dc54cbaec53c2f6b45a30fa7a66d4250925d8663' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/${CADDY_VERSION}/caddy_${CADDY_VERSION#v}_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

LABEL org.opencontainers.image.version=v2.11.6
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
