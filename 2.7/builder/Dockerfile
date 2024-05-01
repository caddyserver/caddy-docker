FROM golang:1.22-alpine3.18

RUN apk add --no-cache \
	ca-certificates \
	git \
	libcap

ENV XCADDY_VERSION v0.4.0
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.7.6
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1
# Sets capabilities for output caddy binary to be able to bind to privileged ports
ENV XCADDY_SETCAP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='bd3f08b2fe678b877a3ba23c8801749c513f066f8c2f8fdcfb74cb0cf305a0063e268f44c407eb614b6157d09357913428462153d16b969a2828c1998872b994' ;; \
		armhf)   binArch='armv6'; checksum='5011a139379d5d62d5c3bb18037919667e8c9bf98fec1d3e4f5ab6ebe82f43e51d64fdbce1d673085b27a9dd23f41a1991141caf9aedd28ef5956b8147320144' ;; \
		armv7)   binArch='armv7'; checksum='06f5ee41eda0571c855d4fcef6f523f892e37b560815f3f5014fe985090173c79d4abbde0efc80d4491d6ac3cfa5609eb220d81a49fb3307b08283c107b81412' ;; \
		aarch64) binArch='arm64'; checksum='b730a207efed951846ee322755c16042cc8135a4b3ae10bb550e3801306b3811b75a72f4dfbfdb2bbe38d4247ce30d52051ca85277abafeb50616f6387e6cb58' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='139a13652eb5f16a84cc6dd3255c6822306487cd3414a76fc174fc2d96bde08701abacdbc7ece282e64409876eb946b1665909bb53413cd1b0574ce1eb1eb897' ;; \
		s390x)   binArch='s390x'; checksum='a722acbdbf74727e3b8fa14a1e7638b2dbe0e0aeb32c8d5af98fd274cd22bb5ea756072a6f3a46bfc8345503deddb876105cb0f5f935e30fd1525962914ed5c1' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.4.0/xcaddy_0.4.0_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
