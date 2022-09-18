FROM alpine:3.16

RUN apk add --no-cache ca-certificates mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/8c5fc6fc265c5d8557f17a18b778c398a2c6f27b/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/8c5fc6fc265c5d8557f17a18b778c398a2c6f27b/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.6.0-beta.5

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='60b035f35cf2659883cf0f1aaedbc88806c28c6722a7793471f894dde8ba734dbbdce96f2da7dbe5d944dc4db16d9e881662f4e28d00e1918454bd14de02d443' ;; \
		armhf)   binArch='armv6'; checksum='67cb947cba30619ff221ec4541ddac0ffca45e9ee665cfa120f491841d3b2f2984c08a98af39283e8f8df3cd3f0ce9e1ad3d52d15dbb2aa183a58bc305709e1b' ;; \
		armv7)   binArch='armv7'; checksum='d5f01fb6811e036bf03cf20d4146649433705a5d0784ba9f8b61227db2658387e6f8aa34a87e06fc793175f75f1a1f9f05a63f010d18001f7ab573229feac542' ;; \
		aarch64) binArch='arm64'; checksum='b2925d00071390489e1509e2f62247db8336a98a109ed7b1a4c0b799611ca793463b7aa066df5b1b54620667eaf5f044d63dce1555b9f4755165b03f85730529' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='c6f8c5c260c19cace5833debe24669e1e5babebe32a363303ba804e8c5b5b31c4e4d6f90ba9880987b38d52f0738672ea0795ed7c7591212eedb2639cc35a75f' ;; \
		s390x)   binArch='s390x'; checksum='e520aa629acaf6fe98b4109f7753c99f3d3141dd669a27172c8232f025269c9f1153a730527e1943175129155801ea02461d39a84359af25fc93f4783ab6557d' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.6.0-beta.5/caddy_2.6.0-beta.5_linux_${binArch}.tar.gz"; \
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

LABEL org.opencontainers.image.version=v2.6.0-beta.5
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
