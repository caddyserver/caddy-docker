FROM alpine:3.11

RUN apk add --no-cache ca-certificates mailcap

# https://github.com/caddyserver/dist/commits
ENV CADDY_DIST_COMMIT 80870b227ded910971ecace4a0c136bf0ef46342

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/$CADDY_DIST_COMMIT/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/$CADDY_DIST_COMMIT/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.1.0-beta.1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='88c141648d1b2f77a3176d36d7448e0409118fa39572dd46f853928033fddc9c593d02101d6923f20acefc8fd7ac701d84dc4276dbc42c3a6c1b8c1e9d26eebd' ;; \
		armhf)   binArch='armv6'; checksum='af8bb19b0c72d0c6e2cf748a62046102cf52c82454bbd32f1c75404188145da585dd2f9cc3848bf99ad9ebb94f546b56b1d2a4db73bdcf4c262e0441cf55af5d' ;; \
		armv7)   binArch='armv7'; checksum='ba1a123791c531d69f677fbd2652429f37eb0298491fd25ae23629a12bec6ad4a33b5e6d25069ccd98773c3036b599054ccf152bf56e791a7435c1592042ca22' ;; \
		aarch64) binArch='arm64'; checksum='e425bd8b3514990de3bfed50375dac6abef9308a3e49d0098b2151b3b5dd74cb1e545e0b15bc2b57b21941a1d8cb4e1dcb1a50c93ea3c3e60d14a30394059b34' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='90cdeda18af8634fdfcaab60d58f246d88756ebae5c716a93e3c09ae266d86812b9e258f894447a3126dd6b37a8e19d5ea7fe0e33543d2a6f2e41bc947de0fd4' ;; \
		s390x)   binArch='s390x'; checksum='db3eea7f378400ff4e12baca105997b8ff5cc4725fc901027e80d6bd4ce127fba7debefd52bbd5e40b54db30d6b2ca96d1221e4179044876ae39cf27e3bdf475' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.1.0-beta.1/caddy_2.1.0-beta.1_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

VOLUME /config
VOLUME /data

LABEL org.opencontainers.image.version=v2.1.0-beta.1
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

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
