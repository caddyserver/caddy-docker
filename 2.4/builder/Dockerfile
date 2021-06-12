FROM golang:1.16-alpine3.13

RUN apk add --no-cache \
    git \
    ca-certificates

ENV XCADDY_VERSION v0.1.9
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.4.2
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='9d3320f829cfd26945ed417bc4cb52f79691db6dce52ebc8721d25c85a857888ae8db10ba500e1098aee92dc44a9d5fbe342b419d0736f525712746f884cf1ff' ;; \
		armhf)   binArch='armv6'; checksum='72d9ac31519dafed67284671d3ed9d401807017d143b42bbdaaeba709123ead0f8082cc5223539622a0493fbbefb25f03c4a28c544ef1d5a02b5d8fcb36101de' ;; \
		armv7)   binArch='armv7'; checksum='65d6d093a27e9699de35e436d5880f7c19287988cbb60429d979ffc0dc5855c0fa778879d9dffd3e6bb5e6efb3979f53d4e3466c9ec7e36c695cf938452e9dd9' ;; \
		aarch64) binArch='arm64'; checksum='2d51dc9c49d10846f8925a0185388b3a539cebba86d80a3b838d9e85e35d80d1786a8f2e519c94f10df4f763bcf0ef3127ae9fe00d940c8a5cda8405445b68a5' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='df0c60f66f25441f3e4f2db0e5565fd632730e3d48ee0ecb2a5da763bde957b5774e085a623409d54b06ff0d0197f38ec2ac11d3642b58cce3eed3360b4de99a' ;; \
		s390x)   binArch='s390x'; checksum='4b9ad777d515fe3ed79ba57f76e4443e95148c8b991b5e00ee04088ad0a0ad88d8e951d56b8001f9ded3c0ef29f674a1b5eaccc2a1f80121bd177aa7764e9245' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.1.9/xcaddy_0.1.9_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
