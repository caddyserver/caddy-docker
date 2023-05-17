FROM golang:1.20-alpine3.18

RUN apk add --no-cache \
	ca-certificates \
	git \
	libcap

ENV XCADDY_VERSION v0.3.3
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.7.0-beta.1
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1
# Sets capabilities for output caddy binary to be able to bind to privileged ports
ENV XCADDY_SETCAP 1

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='3ff3f9f7a26d227988d1595720d152c3908b87dfaabcebcc4ac40b920eac8507c5e138c07823f9d72343a73528ce52fc39004f3215901ab1534514f8830081d5' ;; \
		armhf)   binArch='armv6'; checksum='eaa96703322f3ed425a1c0f65a241bf816aa2b2d918d277d49e4da44d3ba38909e21b6bb422c64b252de4fd78ea6b89b01b69042bf8586acc9f207bc214de520' ;; \
		armv7)   binArch='armv7'; checksum='3bf7378fa9bc12c3e72c815a1030f3b8e55847133259d084b70355ec04d18922720d7dfa30a959f9c0decc0857880695eefcd5d5f0439ba18a93231964a78091' ;; \
		aarch64) binArch='arm64'; checksum='504a04c054e4def0243abd06e56f3be8971ae57fef644fd507df385b3eebd0ec6adacc800d25e850466182104895c48933e7b65a15570eadbfb9c9b272324368' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='e97db6a9968dbcbdf0fe8e18da2847512c48e9dca9ff63b9e405fcedab79ef9e11548cc4c7019b85127cbae90af4c54616231a260a93a290ea545ae04517471b' ;; \
		s390x)   binArch='s390x'; checksum='bd754fb86509cc6f8034acfdd2af4861da72bf79b6801a5b1948c84cc100082226be8a227f1fab88c0554250f767e12069038a033e0f9b31a0cd53872c52b97f' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/xcaddy.tar.gz "https://github.com/caddyserver/xcaddy/releases/download/v0.3.3/xcaddy_0.3.3_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/xcaddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/xcaddy.tar.gz -C /usr/bin xcaddy; \
	rm -f /tmp/xcaddy.tar.gz; \
	chmod +x /usr/bin/xcaddy;

COPY caddy-builder.sh /usr/bin/caddy-builder

WORKDIR /usr/bin
