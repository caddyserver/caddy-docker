FROM golang:1.23-alpine3.20

RUN apk add --no-cache \
	ca-certificates \
	git \
	libcap

ENV XCADDY_VERSION v0.4.3
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.9.0-beta.3
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1
# Sets capabilities for output caddy binary to be able to bind to privileged ports
ENV XCADDY_SETCAP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='98a90298cc5f947c1eda7e900454c1c94b27bffefbca5ee7b844c42ede2816fec617c8c0c70d4e8564110c5f5f73f3f37a6c87d3f49fd201126c6cc17543c695' ;; \
		armhf)   binArch='armv6'; checksum='da22b8afc9b30c89bf2bdc66f6ac6ce1852cfb8ce46742412f2838228affa47bd33f83abee3ddadfd5d9e9493976f5ebe8a75f60db050dba6fe3f400b04c5b92' ;; \
		armv7)   binArch='armv7'; checksum='ace84f56fec6469841e0f712e09742b88a84543f74e66c87997b7895580c17225c1fc57d816e0cd19d8463471a65cfdf0d765cb3fc4f80d1045d4454ba358f90' ;; \
		aarch64) binArch='arm64'; checksum='5f14afb791a25ccd8c4b54000e60f1df80c50a3969a0ea667eb009c911eb673433714391bc62a51cd5f06e6f9c4f9173b942b40c306998ac412319e8e90335f0' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='48e9bddb9f05fa8ca91a9631685f4cb4a18c9bd7cbae2e1fe03f463ecb1584505722dcf8110b3cf7e43dcd08445bbe69713f221140da1f53d562e82907e08d7d' ;; \
		riscv64) binArch='riscv64'; checksum='6c2dbe83713978b5cbad6c1365a9e24868a993c38528a42d6844357a1acb43ace4ebb9b5deeade00378540cc8dafd9a8ab99e007c78610d0488469a4aad41653' ;; \
		s390x)   binArch='s390x'; checksum='5230961c467734555a8e3f6a8183612e9345b67a390b96f2ba26d2a4ad8db67ecaaa7fcd5898faa25a0ce313f1aa905843e0ce760fc14ffbcaa7651d858654c2' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.4.3/xcaddy_0.4.3_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
