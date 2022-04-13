FROM golang:1.18-alpine

RUN apk add --no-cache \
    git \
    ca-certificates

ENV XCADDY_VERSION v0.2.1
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.5.0-rc.1
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='e582db6dbc9a2c91c8d63d8c1376ec89929cafd731c6c53c6aa3f891afc7fe3276963900571a2eb10e77d19109f5e6734c64e70bea85b174e4530fac366cc6cc' ;; \
		armhf)   binArch='armv6'; checksum='cd72e4bf741b424b58c5e19e9626110241bd728cf9426efd03089757c8e551bd50c473b07476f4b4130029838d62bdc0165a1e8ff5c0382de750f8217311cedf' ;; \
		armv7)   binArch='armv7'; checksum='6351c947c340916f87789a65649322d537be2949003d679d19900af8e44ab6d0c15918938b7bdd022ff748a3d587d5c7f42d2d5310ef3fd49961b4382af77820' ;; \
		aarch64) binArch='arm64'; checksum='e4697334cc01743b12f9ef3338923a5b8a4d51c17fc701d685d4a281f667a1a2378496d9567588ef7c01de3350eabf04455370f19620099b6f1cec6abf2ae54f' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='3c4950414ae1b30e230f5766403ce0186f8e3badce8c097d54278df9ff942adfeffc845765d6d70a5d0d3352d548f2bfd346adfecb3dfa2e6903437aaf8bf0ba' ;; \
		s390x)   binArch='s390x'; checksum='37cdd2e135760e2d9f58c47ed68b3575d281b0b710a70764cd27043f26ede076f2c3861c870546ecd931af23e6357a5cb87b52ec64ab7e5983e7a837a3131eb7' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.2.1/xcaddy_0.2.1_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
