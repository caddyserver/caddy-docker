FROM alpine:3.14.1

RUN apk add --no-cache ca-certificates mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/a8ef04588bf34a9523b76794d601c6e9cb8e31d3/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/a8ef04588bf34a9523b76794d601c6e9cb8e31d3/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.4.3

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='1b39843c198a56ccaf1af19edfe51ff2556d6c9081cbf52bbf8d697777af936b24e872561ca0b35aafa0c84b05c86faa4c2ccf463ffef31bb7140fd09211595c' ;; \
		armhf)   binArch='armv6'; checksum='9a1e606bbb6d965ab92b7bcae6a5b58fbffa7f9bec77be3321509e3175e18c8f9db785af40e91bc570f799ea9c44756ff0694439a0b4d30574ea50eee7854693' ;; \
		armv7)   binArch='armv7'; checksum='67c1af278bfb79daaf7a2717206b94e09ebfac433c5ce8ef2bad1e1233d626c5b57e822a0c29205b7c62561a06772f116d7dcf072ebea4b3148f0bbaa2f61f6c' ;; \
		aarch64) binArch='arm64'; checksum='fa105a900a21f02175a1ab1ff2d0db4f171832183f231d59f265d3f728ac9ec7ff4f2b2a951dccf8f6d7a7057fc69e5670db18bd150ff5bd63df3f72c81cff39' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='71399082625f3059208e590b5d13c700757bcb077063115f26f257ab83b3c51d35eabcf70f0cfb426cb5cb59193ee15301dc2f35b22d2d23f6cf8678c84462a6' ;; \
		s390x)   binArch='s390x'; checksum='96c9bcb89fb1083c3a293ccc3568b58fc64cfcfda4983fd244a20be07b1b5e26b54bf155d0e472f035d584f1484bd17073c27a75b72adac7d3a820a616015887' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.4.3/caddy_2.4.3_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	chmod +x /usr/bin/caddy; \
	caddy version

# set up nsswitch.conf for Go's "netgo" implementation
# - https://github.com/docker-library/golang/blob/1eb096131592bcbc90aa3b97471811c798a93573/1.14/alpine3.12/Dockerfile#L9
RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

VOLUME /config
VOLUME /data

LABEL org.opencontainers.image.version=v2.4.3
LABEL org.opencontainers.image.title=Caddy
LABEL org.opencontainers.image.description="a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go"
LABEL org.opencontainers.image.url=https://caddyserver.com
LABEL org.opencontainers.image.documentation=https://caddyserver.com/docs
LABEL org.opencontainers.image.vendor="Light Code Labs"
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.source="https://github.com/caddyserver/caddy-docker"

EXPOSE 80
EXPOSE 443
EXPOSE 2019

WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
