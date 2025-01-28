FROM alpine:3.20

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
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.9.1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='0412057ba591c33bdb66034d7f32209619ce635147dac3084c79abcbc118a761145e695199f57c6798d88fab077f2b0d9cb999f52ded904c6d464a4eba202932' ;; \
		armhf)   binArch='armv6'; checksum='4553157b1b3b9e82cd5f6ce7dd5a960927c8a9f96d1c6bfb376be80407a494c9d487377d8c6f77a82e80066f052d8b4f9e2640615f9c3c855e3f53314044d565' ;; \
		armv7)   binArch='armv7'; checksum='9650abc74b2a2f014a086536fd52f0c6827adc36e27e82ee3edd8ed2ee82c8bb8f274b5d829be1a809c632214b7d931bd5e760f4cbf87d7d31e3e8ec5f934652' ;; \
		aarch64) binArch='arm64'; checksum='80b917c2bd8aa0892f1386ff97af9e776067dd8cdc4793238869aca7e13f7280f89d1799a1fef08b49af92dbd86684c3ba7a38b9d44afc55ef2eeb33b49e1cbd' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='93383bc8f231028810019db624e7be16754db1f3d84f6b9455f3b53275129f208f1ba3a02ee98ebd6b45e61263208d61ecb1b451c429c841988202a373423a34' ;; \
		riscv64) binArch='riscv64'; checksum='f6707928f9b2ece9d82a6a1f9ae2154662b79bc9a0747bb0ecb0971b368a4afb1f78b44cda6a6914bc0fdbdeac601d037d5c767801dd41441377d508cf5cd3bd' ;; \
		s390x)   binArch='s390x'; checksum='0211cfb04d172eba794831e01273414f983b2c1b28ce3c0b4e5ca829579fdbe43ec2df163f9cb951b778d8ac3579fbcb873b33963b98504fd1d0191e3866b2ac' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.9.1/caddy_2.9.1_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy && chown 0:0 /usr/bin/caddy;\
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	chmod -R g=u /config /data /etc/caddy /usr/share/caddy /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

LABEL org.opencontainers.image.version=v2.9.1
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
