FROM alpine:3.12

RUN apk add --no-cache ca-certificates mailcap

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy \
		/usr/share/caddy \
	; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/506330b23c5cce43a9352179e7977a684678fbaf/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/506330b23c5cce43a9352179e7977a684678fbaf/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.2.0-rc.2

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='1c83bc9008014338de8de9fadc3a70855cdbe4ed624f8943434507acb3350a97e051f4fba60efcf2742e542301ab97802ffb89208a5a56a1b1cee40662289bf8' ;; \
		armhf)   binArch='armv6'; checksum='100c4d1fd0eca8de1b1c592e67efa4e87a91a32202b1b5796ab99ab565f96ee6918e5f092b995e74d3343f569376ea3eb956e2361f075f094c1ff0fcdf161443' ;; \
		armv7)   binArch='armv7'; checksum='a3e3a1d3c252d5b95ca6e2f85483608e1a0d74dfa9c25a6548a55485cd596711252f4e7ea4ee6daeb764fd1939b7ea237f78dc02ebe60781be060511a6413ec7' ;; \
		aarch64) binArch='arm64'; checksum='ae6ff928a62d0a1d4b142183c83fbdaad427e3b6747eda58b8dfbd426ffc010285bedb733868594a39058d75333c98b10db46f24210ae1a467a1dc59ca23e0f3' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='0f11fb5560ba61286a9bd1629a4397d3dcf09222a214df1c5eafe68886a222edd1973f363dbe986325c8f4983d88b87326ccd11ce489056170f49900bc209db7' ;; \
		s390x)   binArch='s390x'; checksum='8b4e14a7a91378b42da4c39c14b6987308a6328a60555eb1d02ff729b801f603675533cf1e034f60be9586a99a890510439750bbb959d5aaf0b479c8ab94a99f' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.2.0-rc.2/caddy_2.2.0-rc.2_linux_${binArch}.tar.gz"; \
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

LABEL org.opencontainers.image.version=v2.2.0-rc.2
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
