FROM alpine:3.19

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
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/d129ae6aec6af2182217ee8a235f4df8cd2bbfde/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/d129ae6aec6af2182217ee8a235f4df8cd2bbfde/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.8.0-beta.1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='64223fc364fbbdbc4c5f30a2f14133e198dddfe537e98c8d41884b22199f6de5f1a4b908a7349a852e4b6a4e63e9d40271300a7613814021e3c6b44de1ec021c' ;; \
		armhf)   binArch='armv6'; checksum='f98b50dd3b6cbdf01a1373c3739c5510d970c45c331d4667850047846ec6e1c41cbeaef47b59d67c571e83fd2d2cb49cf8b9e8ca45f8a8094c29558ea57d1447' ;; \
		armv7)   binArch='armv7'; checksum='4c7e282a677b54dc77716973e0ec97141fdf10ccc2a5e82844ab2def85f454262672c1559cc0f77fadbf28bf4a31de4f23c56f251c4816da1e5664c140c05cb7' ;; \
		aarch64) binArch='arm64'; checksum='b943590510c0cf06f2a10b312d7bf0d1a1ff540b47efc08dde4ae0ab06161f5462c0d7e7af9eee75928248735d7ab0bf5323d966ed75ab71b48d3ecc80a6d677' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='5105e2088b162c6e88f742f3242d775ceead7e6b6cd23fccbeda65635d589af174df489c7bc2b96c865a39b8410cb296ef5f3b3865a358d52cd9999e40eeb0d9' ;; \
		s390x)   binArch='s390x'; checksum='708f0b7567e1a91e9ef84437a84ded3d398917e76bef92b9929101226eb9a6816d69ce1881a93bd47e3c419a177c52602ad09d8220b4cb010e3d8d60a53ded6c' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.8.0-beta.1/caddy_2.8.0-beta.1_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

LABEL org.opencontainers.image.version=v2.8.0-beta.1
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
