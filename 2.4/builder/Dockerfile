FROM golang:1.16-alpine3.13

RUN apk add --no-cache \
    git \
    ca-certificates

ENV XCADDY_VERSION v0.1.8
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.4.0-beta.2
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='41daeac683d503264496689c6271645293c95518c5b97870c3f3a17127ae35b820622720315901c0c5856b42e0201b7eaad153dfa4a1045502a99f41d0b9785d' ;; \
		armhf)   binArch='armv6'; checksum='51e4d7220064e1948232c8c54996b012d01fe0e2caa71200e34f0da59bd6267cdc318124e1a7a44e83ce54b7276f6d0fb32381d3080e05902d3c3528ff423dd7' ;; \
		armv7)   binArch='armv7'; checksum='9c3b4eea4840a1fe633d45d436789edf6839e96527783d2eac309d24e5085c0cdee8beffd7e5ad2f1d7d31e16004e916aa29456d8ac52007e9d904e644d6db40' ;; \
		aarch64) binArch='arm64'; checksum='86cf83d11aee266d32c262982df3e286aa0a4b391fc4fbded0e299ace043c753e9a1f53bef1f95a292a71107e1f9578a8615b038871eedb171437eebe7db47d2' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='81b050dae2892feb517db6c782acc506dfe21399b0a79073e5191656f57c6d0a5a511caf1086ffc671712ab198715cca6a2a120812a4df8d774ba17d6242aa39' ;; \
		s390x)   binArch='s390x'; checksum='763256d267ad8832c37fa1a902fc06dfb6b9871b75e38545cbc199b50251f78b0cc2400104d31fc18d2c98408f02a74e581a7f7746974837dcdef51a4a259bf2' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.1.8/xcaddy_0.1.8_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
