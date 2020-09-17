FROM golang:1.15-alpine3.12

RUN apk add --no-cache \
    git \
    ca-certificates

ENV XCADDY_VERSION v0.1.5
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.2.0-rc.2
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='1c83bc9008014338de8de9fadc3a70855cdbe4ed624f8943434507acb3350a97e051f4fba60efcf2742e542301ab97802ffb89208a5a56a1b1cee40662289bf8' ;; \
		armhf)   binArch='armv6'; checksum='100c4d1fd0eca8de1b1c592e67efa4e87a91a32202b1b5796ab99ab565f96ee6918e5f092b995e74d3343f569376ea3eb956e2361f075f094c1ff0fcdf161443' ;; \
		armv7)   binArch='armv7'; checksum='a3e3a1d3c252d5b95ca6e2f85483608e1a0d74dfa9c25a6548a55485cd596711252f4e7ea4ee6daeb764fd1939b7ea237f78dc02ebe60781be060511a6413ec7' ;; \
		aarch64) binArch='arm64'; checksum='ae6ff928a62d0a1d4b142183c83fbdaad427e3b6747eda58b8dfbd426ffc010285bedb733868594a39058d75333c98b10db46f24210ae1a467a1dc59ca23e0f3' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='0f11fb5560ba61286a9bd1629a4397d3dcf09222a214df1c5eafe68886a222edd1973f363dbe986325c8f4983d88b87326ccd11ce489056170f49900bc209db7' ;; \
		s390x)   binArch='s390x'; checksum='8b4e14a7a91378b42da4c39c14b6987308a6328a60555eb1d02ff729b801f603675533cf1e034f60be9586a99a890510439750bbb959d5aaf0b479c8ab94a99f' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.1.5/xcaddy_0.1.5_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
