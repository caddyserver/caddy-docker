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
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/509c30cecd3cbc4012f6b1cc88d8f3f000fb06e4/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/509c30cecd3cbc4012f6b1cc88d8f3f000fb06e4/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.8.1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='866b6186626d4a7f35d5c010f3f532b022a35dd21f3512bd2015d6de39add0ccc0e8f778878a927ea4a5131ed1dfa8f114b1b9831eaa741f8aebc5c2d88747fd' ;; \
		armhf)   binArch='armv6'; checksum='7cb786e8f1af7573ece485f2a9348c3ba7c6191346f5917075027f5cf5309fc0b8e3113e48092fc723d01171cd3c8bdfd076af17e69b1a6c1a9a0d5e53fdf1d2' ;; \
		armv7)   binArch='armv7'; checksum='e1a7c02a0986d260ead1ffa9023e78bc1903139813ef5233a06d1f7d621f71ce37eb0042a991287256f85dae64924278514d183bcd805ef0329a096e4574dc06' ;; \
		aarch64) binArch='arm64'; checksum='1a619b1ad15fc2163fa597a00b2c6174e6d00b8ce5206d18e0691edf9251ac8dcf1ebf059d7bd065a9ce0b3427071943dd2385d27fa78df0678cefea07280154' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='c6d9b6a8db14b4a44de453023ae7b9d6f85b646dfb22a7e4bd5859556fb9cc42e1fb16b3ea5312a2b97bce4ab1f87a71daa430dc57cea09c0dea739409d5434f' ;; \
		s390x)   binArch='s390x'; checksum='312ff46594f445d643acbc0d2f118c5af9419dd9e2ea1a8398a8a7772d172ec616d79f83eb4e3550efd26188c3fa1ddff1d9255bb3a55fe6b4384b0db818502a' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.8.1/caddy_2.8.1_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

LABEL org.opencontainers.image.version=v2.8.1
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
