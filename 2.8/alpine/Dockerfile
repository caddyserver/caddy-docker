FROM alpine:3.21

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
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/509c30cecd3cbc4012f6b1cc88d8f3f000fb06e4/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/509c30cecd3cbc4012f6b1cc88d8f3f000fb06e4/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.8.4

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='b8bec15d14fb033562af9f207850027bcbaa1f891edc9efe00d38bf39e1bf9944f8b6b8eba041ddd4c171cd70c905174c704d705be2f23bc678fe1eaf37a2485' ;; \
		armhf)   binArch='armv6'; checksum='640536eee0645342a8cb3bfe6ca3ad5bce8a22fee371eb295192d4e95971802a4f4dbe3a188d2be577762547f713e8ac708f8e9b6acf4806cdf509ce54954eac' ;; \
		armv7)   binArch='armv7'; checksum='8aecf8866a6dbdc46d550d2d957afc26dd262a8fa1fd6feb122df961ef57d2301b720556e6ff180f1ea0ae19e13f1cc6ea9935eae58efb68b8821aebffe989f1' ;; \
		aarch64) binArch='arm64'; checksum='5466234be3e988071cef937aedbdd94c15b6f75cf7307397e67c2641219ac9bfe2c2bb3b31fc05bc68d3b6398bbe50abfa16ccf3b127318ccac31115ad26507c' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='90c4a779f52b86d4b615a15acdec01db986a88fb606ca11145c21cfc4e64b417296fe0a54416f2c295600f8a2994a073a40028b1b1583403b416464bf39de173' ;; \
		riscv64) binArch='riscv64'; checksum='67ce559ca785f05b54b587f91f12f8c4c46a7d14e3f72772f14922b672417473b4e76ab61dd939b9b710889ca3a0604cd7f4c78ccba8e6dbfd5fd5193d9bf719' ;; \
		s390x)   binArch='s390x'; checksum='ed67cecdb9f50379d75805ebeb687183f096d3206cef053b768e87eceb4472fd568f47ef8fe0939f019f38e298a3a41243ba9caa193f57e7b29e4daa700898bc' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.8.4/caddy_2.8.4_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

LABEL org.opencontainers.image.version=v2.8.4
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
