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
ENV CADDY_VERSION v2.9.0-beta.3

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='c38d63d3dc58e50cf6bb9af873f61c265624dcdaf5eb2de834f309148d0faed162f83d27b073e729318e63f28cd2958c93a5e0467fbbaf82624b54925dec97dc' ;; \
		armhf)   binArch='armv6'; checksum='aadf515dc43ab035d75595414560c8d9168e4b5823feef441b7846170ac5c9d4ed382c2024b8c8fab2cb4000cb89612870aae9a15f355b15f5931c63b75e06b5' ;; \
		armv7)   binArch='armv7'; checksum='c9a189a4d92c4872d429a6f5dffb12a53237dbf8a98c45985d531ab71200d84a49c9d120026799035cb03cc8c75a37be07e65d590900976a82cdf6355f7872aa' ;; \
		aarch64) binArch='arm64'; checksum='094c0f5a82dabafb707f050d637a2858f3ec0a4865d99f51808a76a30e4e2e466d4534ec48fd830b369c7c9e2bcdfb9fe3132fdbcf94dd3256d5f0bcc6b0b062' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='3dca4a42a50540f5256a49528dffcf6456a571392ac6bab628933e5dde0b344eca39920625982d426e741c4af3bc38a8a20373a082d9cd332a19e293c60738e5' ;; \
		riscv64) binArch='riscv64'; checksum='ba28761fa1809061884dea5487f23b4aae19ce02902982ae424f1916489a7934056f2a18cff1a08808d545c5ea97022e3f5ca9a28e23aa9aa90a775a50fd93dc' ;; \
		s390x)   binArch='s390x'; checksum='fcd39452bd96f952eb66035acf1d3493a6f4884fcedcc52fae3dc700e3a1e280b862facf2d4a6a0150d652116796e368e73756169ca8924c34e102be4b0ab24f' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.9.0-beta.3/caddy_2.9.0-beta.3_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

LABEL org.opencontainers.image.version=v2.9.0-beta.3
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
