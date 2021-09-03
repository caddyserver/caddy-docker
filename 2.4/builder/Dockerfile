FROM golang:1.16-alpine

RUN apk add --no-cache \
    git \
    ca-certificates

ENV XCADDY_VERSION v0.1.9
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.4.5
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='1a19a8d94c6c16d8e671c4dad1e835e7d0d586a36e15f5300b374e5d31cf10eafdf07bc2c24d5589cdfaff1dd276e4627917802e858e14dc2351797d7dec7586' ;; \
		armhf)   binArch='armv6'; checksum='5b68e8b9491507591bfa42880a771f5c687e9e081ccc249a2356b0a1cafc108214e6915d86a5342e6eb99c329942cd027bfd8960d38dae11c91a47a43926b1a8' ;; \
		armv7)   binArch='armv7'; checksum='e39210f8e3634ebc85a3a32bda4bcb2263d508744f8ba3b2e9e56012cda17cabe16f2318f991e3d1d8306da49fcc2fa3bfef98f3412bbcf734376ea3bcbdf2ea' ;; \
		aarch64) binArch='arm64'; checksum='da23940ff938c953d288555366e09632b31fd248e337da1990cebf0471957d14196f38396fd055d4b409f9960e2d8fb94b26ab435662a871b5ea300b9e77ad25' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='cf8d73a238628cfacea7d309f64248a6e25c76dd76a669a646845b4ca729fd677e30a2a29c75936d810b9f55df89fa17f9b6bc42c5d69e8e02b12ef4e334ad91' ;; \
		s390x)   binArch='s390x'; checksum='21631de0d9c93346a9ab8658990c87bacda9c401ddb4b850a59f0c9f9665e0b93b02c0516df55eb03829f0eb5fb546683ba2d5e7b8f6174a7dfb3d13db9d81cd' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.1.9/xcaddy_0.1.9_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
