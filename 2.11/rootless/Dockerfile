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
ENV CADDY_VERSION v2.11.0-beta.2

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='f9c72942891b3983d26cd96a2353f0985de3381f0996ae2fd37e9dc662c3b78a6cdad121d5ab225ffbe36d9425b46c5258c08dba707299a111d41ede7228171b' ;; \
		armhf)   binArch='armv6'; checksum='ff625cf10b3af39aa55e9f912342fda2868b2de8df1a3da543ccbae998cbe5b7d12ebb707edc061ebdb6df3c656a8c3a67743f5212df2132c4ce6f26bc8bf057' ;; \
		armv7)   binArch='armv7'; checksum='de69fc54499bcfecacd1f37533ebca116545bd46d27070d6858b042c61e11d673a13bf4f08db238ead6d54ed79a59c7ce2ce103ac94241715cfaba5034861541' ;; \
		aarch64) binArch='arm64'; checksum='e3caa4eed7104549029aa31074fc8f9e0399706c787a7ad22d23135d0c765ced8e9c2577fbb0b1e8a000042d86ad80cabb49e85eaf973e18b435926cc8b356fd' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='ea4a8ef21630b5363e7c3f62ebb7926d152ac4fdc854fe374b08eb6c0edfd50dbb5c6f01b5c89aad1871b83690fcd4f9178ecd64db9544dab605161af0352644' ;; \
		riscv64) binArch='riscv64'; checksum='f68fd4802b8d77e8b7fcc4eb1d3576edceabe9494edfa07fee402b4643aa2cf3402f88f049bafa2995ddf4dfbdc2aa569abb7056e9696d94360725b25e5df91c' ;; \
		s390x)   binArch='s390x'; checksum='e809207408cab3d9c96c7c70f832f244311c5e2b5546ad4e15179cae665c0cf3a759692ff0f8de0519c3b587309b2b892ca0559bf7ac9c3244f3ed851353cfa5' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.11.0-beta.2/caddy_2.11.0-beta.2_linux_${binArch}.tar.gz"; \
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
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

# Set default HTTP and HTTPS ports to non-privileged ports for rootless operation
ENV CADDY_HTTP_PORT=8080
ENV CADDY_HTTPS_PORT=8443

LABEL org.opencontainers.image.version=v2.11.0-beta.2
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
