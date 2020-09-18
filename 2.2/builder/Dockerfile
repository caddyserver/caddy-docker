FROM golang:1.15-alpine3.12

RUN apk add --no-cache \
    git \
    ca-certificates

ENV XCADDY_VERSION v0.1.5
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.2.0-rc.3
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='05ca569f22d55e61b75f7813b9d9cf0b8a3d9d0308cd1cc7d89463b0e97f864bbbb00386103d88cea323099310a55f12407e7547b32631a0c41e850cc3188159' ;; \
		armhf)   binArch='armv6'; checksum='9e7ae77cfbc0e36651011afe59273b533e7bc8e2514aad98d3ee0c4a301cca82fe89b19d98d291de34ce0e07d1c2e4a57709fb386cb687ec83e609cbfaf84d7d' ;; \
		armv7)   binArch='armv7'; checksum='8310eb2b18ec9afe5aab5d64f7b8dc04fcdac15106b6e3a767d4081ad3ed184de6981f87eb184c80d4ff49e9067ee36b9b6703eb400509003c6de6a2ed8588f3' ;; \
		aarch64) binArch='arm64'; checksum='717c289c53fcaa6ed33cea8975fc4350fa95e61e3c703a82771c9cc9b1951572c996c5823ea9cc6ad2e2cecb841bea6dc51a8fb0f95fbdef8dbb70620e6b39e4' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='2c96c8e83da29be72617d4a8fa2f9eb747974bbf5129f27a4a8a5ec7b5b0ef73a315652435cd0c097e27ffa4aff1ed2b31e6d7ee791aa113214582aa69f1a1a7' ;; \
		s390x)   binArch='s390x'; checksum='6306428655b66cd53ad274a42b4c572109ee5a2c9cff0ad0bdb9912174089de94222dfa1ed0b5ea3fe5ff7bfe970fc884a0222325684b4214ff64a9e168979f9' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.1.5/xcaddy_0.1.5_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
