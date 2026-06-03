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
ENV CADDY_VERSION=v2.11.4

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='8220d1f013b6f27510247b2360c9e0ca9f018feebd82515f07635318b34ff9777ccc8fd0b6e6f2486ce3a33fe389fbb7db12d05baa474f4587509fb4f5ebf1c9' ;; \
		armhf)   binArch='armv6'; checksum='d4300f3e0d9af290bebd65721edb145025db680e6a7e6ad2ed917bf8c9d6e72abe788f720cdf046fe210ca1b43f9a7ddcda07a634296d3012527299ab78cc3ed' ;; \
		armv7)   binArch='armv7'; checksum='081959488f0d0da2725aea2d01330bc1501b3e52c1147b6c9da1da007524890ceba6845415355ba8f97aa29535e6f37521da1d7f10c5c63c55bb86c5d9f51bfb' ;; \
		aarch64) binArch='arm64'; checksum='d5a7c423853c24a799765e0e8210d5c7c22a8f56ed37a3cae2fb9f58be138853c02b4efd6b59d576e6d8c7c0d30b9c1592deeaa6a536ff69bcca23b8c1ea709c' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='74b11a1f098517be7e6b11c7f7da6b5a0be9a18634f9a575c5ba6f5518a1bcbe4fe903f6c32a6d7ba47464fcaf12fde95e5f301cd829c4f41633484b0a4f817a' ;; \
		riscv64) binArch='riscv64'; checksum='05187bfc217a67ab32bbb0ebb9bd27ccbac0f80e41ad47dba272d10c34b1bf00f67a57ba05230eefa791898b2e2f40158631d81c3639cb514d59ac6d4976b044' ;; \
		s390x)   binArch='s390x'; checksum='fc2cd4294bf43e6645ee639532361c8e432a2cc7639134cfa0f0c44724146f4d9a278542ed56399e53aaac857b767d26ae748e754a790d106dd192c4c91c09f5' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.11.4/caddy_2.11.4_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

LABEL org.opencontainers.image.version=v2.11.4
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
