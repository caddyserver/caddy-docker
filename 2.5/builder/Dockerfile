FROM golang:1.18-alpine

RUN apk add --no-cache \
    git \
    ca-certificates

ENV XCADDY_VERSION v0.2.1
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.5.0
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='9acd4fb788ed19bfe0718e67b23f259d8af3715e87670fce63667aebdc615351eac438066d617a8869da1dcf44cb643694dd479212065b2b79a5ccb52d667ae6' ;; \
		armhf)   binArch='armv6'; checksum='af1f44c727849ac65a7d842de5f3f8c12e09d0c05f02a84c298e360ea0d0b285927bf1c5a3df6e9eb5f328b576fee6742a0357bd4a8d4cf329e7d624d630b93c' ;; \
		armv7)   binArch='armv7'; checksum='a5ad120205237d1a2914dba5670c7ffd930fdfd3523bd2779616995bf7a6560de76a4b6e32a1c557cf9217f6cb802299f46ad076c4718d00fdb4b21c8ff55647' ;; \
		aarch64) binArch='arm64'; checksum='37be9629eae6dadd257c5beaf32102564b77d7b8c8d97aac5a2bc8e93962a55afe25fa315f36a5f132665cb4124e9f33c0f5d8a253c60a994bc44d20a4428381' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='53dfd99f56ee682f88a4d631d3e8b34bad91ca51af39298bb07bab9290d66d6a4c2557e5103a1600a875cfa928be44febc88544ae0d42692d6c9a9479ab8479e' ;; \
		s390x)   binArch='s390x'; checksum='b65614c618d3a9e8200389c2434291556283ffc39b834523893c75b2a335e7253bf8a571b310e2a4c60e24141fd32a5e66d0774434f443002753331b42ec3737' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.2.1/xcaddy_0.2.1_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
