FROM golang:1.16-alpine3.13

RUN apk add --no-cache \
    git \
    ca-certificates

ENV XCADDY_VERSION v0.1.9
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.4.0
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='dd6427ba877d286f5af229e439e59a05afe840283c7674589f46a3bd2bcb25f2162295d55c705f052318a85de23f3661f8322628e952cc1a0f784a8068f68357' ;; \
		armhf)   binArch='armv6'; checksum='088f011a1e71fa3312b907bcdcfe545ba69294e3310acdcccf453c7096498dd61bb818cd19e1fca164711e878a662965bcbfd9946574a20403f71711537a76de' ;; \
		armv7)   binArch='armv7'; checksum='32fe7ff1544e3845b181fadd394383f31522239476f7df031f048856ec3ae73264f70eb3934e6074b7bba385e1188cacef6b7c941e80b1f9a303711eecae396b' ;; \
		aarch64) binArch='arm64'; checksum='2c4fa4ce1465e1dc8e97d669bde9df50a06f4c21a916e59d32d5a4af7be449fc3f0f18303e43ff95655202832898bbdf02148b4aaa1e9e205d487ef14482b31e' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='1ab37dba5fea5e55a403b51d59faa1d4ba74eb3065584fdf585562ae88de6396b5296e5d3c107e5bd2a08cc4e77dce2a8ee29f291a5d4639b4a097b47de9dbf9' ;; \
		s390x)   binArch='s390x'; checksum='ec9319f3ade6ead60c2b6c1a8c5649ca6f911efef938970fc1f08a613ecf9d582b507aad178a7c75fdcf502164cbf4f4563553c40be2ced529c6b0844def8341' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.1.9/xcaddy_0.1.9_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
