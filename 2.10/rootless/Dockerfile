FROM alpine:3.22

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
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/welcome/index.html"; \
	sed -i 's/:80/:{\$CADDY_HTTP_PORT:8080}/g' /etc/caddy/Caddyfile

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION=v2.10.2

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='747df7ee74de188485157a383633a1a963fd9233b71fbb4a69ddcbcc589ce4e2cc82dacf5dbbe136cb51d17e14c59daeb5d9bc92487610b0f3b93680b2646546' ;; \
		armhf)   binArch='armv6'; checksum='95b71fd99595018eebf4890782de63018ee86455531380b2a83a1814bb09c2588c0a531c877a26ba8a16a5b78072a1c26f7548bdec0e18abcef423fcc31a2e0e' ;; \
		armv7)   binArch='armv7'; checksum='215af42cf952726d962c9753a12c04248781221b66df8b7110726fa7905d7a5c2e50056e0b47ab3c709d3dcfb48fde0f11e184a6950de0a2ddf941d3e503d07b' ;; \
		aarch64) binArch='arm64'; checksum='6ce061a690312ab38367df3c5d5f89a2e4a263e7300d300d87356211bb81e79b15933e6d6203e03fbf26f15cc0311f264805f336147dbdd24938d84b57a4421c' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='ab286a51e0e8ce79393519b0c7ebe99075f4539b57f6a34fe555ba8060f8fbaee36197a1e8e49d0050ab5d6a783253839bc2675137635f8d252aea27f2ca5a85' ;; \
		riscv64) binArch='riscv64'; checksum='e71c8ba2462990e0d8a67c544b694446ad36d045bf40ce641fae6774181677457f6ae8ed0b5c4c927ef8302d91c587074b6001318f377d7054113b5da6dee6df' ;; \
		s390x)   binArch='s390x'; checksum='b8aaa737b63308fac14cf84d7a658d9a0d74d2fe5f6a2eb57ca3ce7c52a73bea702c95da73ebfd20b3206bfb7b71ac8613aef9797e0f7a2c2a04bf5083092c2b' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.10.2/caddy_2.10.2_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	chmod +x /usr/bin/caddy; \
	caddy version

# Create non-root user with UID 1001 and root group (GID 0)
# OpenShift will override the UID but keep GID=0
# The -D flag creates a system user without password
# The -H flag prevents creating a home directory
RUN adduser -D -u 1001 -H -h /data caddy && \
	addgroup caddy root

# Set ownership to 1001:0 (user:root-group) for OpenShift compatibility
# OpenShift assigns arbitrary UIDs but always uses GID=0 (root group)
# The root group has no special privileges despite the name
RUN chown -R 1001:0 /data /config /etc/caddy

# Make directories writable by the root group for OpenShift compatibility
RUN chmod -R g+w /data /config /etc/caddy

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

# Set default HTTP and HTTPS ports to non-privileged ports for rootless operation
ENV CADDY_HTTP_PORT=8080
ENV CADDY_HTTPS_PORT=8443

LABEL org.opencontainers.image.version=v2.10.2
LABEL org.opencontainers.image.title=Caddy
LABEL org.opencontainers.image.description="a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go (rootless)"
LABEL org.opencontainers.image.url=https://caddyserver.com
LABEL org.opencontainers.image.documentation=https://caddyserver.com/docs
LABEL org.opencontainers.image.vendor="Light Code Labs"
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.source="https://github.com/caddyserver/caddy-docker"

# Expose non-privileged ports (rootless containers cannot bind to ports < 1024)
# Configure these ports in your Caddyfile with http_port and https_port directives
# 8080: HTTP, 8443: HTTPS (TCP), 8443/udp: HTTP/3 (QUIC), 2019: Admin API
EXPOSE 8080
EXPOSE 8443
EXPOSE 8443/udp
EXPOSE 2019

WORKDIR /srv

# Switch to non-root user
# OpenShift will override this UID with an arbitrary one, but keep GID=0
USER 1001

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
