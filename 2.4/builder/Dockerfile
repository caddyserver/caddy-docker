FROM golang:1.16-alpine3.13

RUN apk add --no-cache \
    git \
    ca-certificates

ENV XCADDY_VERSION v0.1.8
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.4.0-rc.1
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='c5b1f2f25e9551817e80084edada0deeaa75a133d693d9bf1e6d667f9bf42fab2338e65a2b564d41c8bdf2841fae4b0f0a4fe204aa30f7ab80dec65a662ee8f6' ;; \
		armhf)   binArch='armv6'; checksum='805f7d0d4e9735e7670fac81e822d7801708f1ea0303f17c1fe4a1d05fdcdf9b3eaea65fb53812717bea6925fd6f5cab194722762a0f70c25645cfa08fc0a395' ;; \
		armv7)   binArch='armv7'; checksum='6adebb5be8f31b7f563967abe54dd5fac28a6aad80d863a6d24781213eabba31e08cdb5c0a25ddbdcdd76cdb7b0b4b26e82acc2ebe7fdad4c209b3de382408cf' ;; \
		aarch64) binArch='arm64'; checksum='17829b719112fdda07e716bfb740cef6bf1163735305bce9c01a94699e9fbaf0a7ce16f0981b49fa06b9fa11101837448ab183bd0095b739c39d056f0f77bd83' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='45e0ac82b829d164ab63cb344e8e2582678820a28953de9f1018b1343bd5d993bbe042fe9b57ed74652110a46463e2ae6b70c3437838dc2fa781baf9f0c037ba' ;; \
		s390x)   binArch='s390x'; checksum='f143ba8439c0c400094f20b4c49f6e57fc6356052e3a00ae5292f68d15a9f55ff1d1ad7394fa5453ad893ef480ca0f828ad957b29feb168628f84c28c2eb9377' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.1.8/xcaddy_0.1.8_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
