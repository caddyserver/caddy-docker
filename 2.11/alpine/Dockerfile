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
ENV CADDY_VERSION=v2.11.2

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='2513b289054386b76642a9e8bfc10d217df2b5361e4cdd0c72672b0eeab57ae737d57466eb70f1a44233cbcc697ecf21de88137ca45ef4b64f150a32b58f5f14' ;; \
		armhf)   binArch='armv6'; checksum='bdce2a9c07a17d1ef36fd81cbfcae282de5b5ecc1b911592463e9f06033ff395bbbc2322bff557d086a614223c005f046cc0d5679b70813a8da3c2e2a93463de' ;; \
		armv7)   binArch='armv7'; checksum='acb0dc3ece97922b374fef492682b7ecd6d302a417e01abd12570360f055ebe1673d6032a987525475c1181eee7ea7c2efc0b17f1aeec1799303a1efa57deabd' ;; \
		aarch64) binArch='arm64'; checksum='630d1e096e3c9594fd2f4f7129356ee5d6c7e53d0ca1b9a0c7486612c6d752ff355c96738c7a28c60367a5f1da4b51afca731bb745fb0b97cda4c811214cdc48' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='2f885d026be962b3959cb24adc2294c30f4a385b111216d8aa4296adf700854065c62b4bae7b32228176c8c26ac97193db3a7a38fdffaf74cadde1293ad2e304' ;; \
		riscv64) binArch='riscv64'; checksum='4fd9ed8feaa3f239901fd3376897a132ee05c467d73c8b448163cb341c570208b9907ca316a1e475a5b8d4594507a1c5cf65d6cbe2e309af81f7b8a620b3796b' ;; \
		s390x)   binArch='s390x'; checksum='d9f6b53330aa36badcde1cce49f38e4e577c24b91ea522eb6680fb49e07cda3b2ee83de83a7e253c3ebf8f2ec38f7de16f75c09a8590c1bf126bdc67df576185' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.11.2/caddy_2.11.2_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

LABEL org.opencontainers.image.version=v2.11.2
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
