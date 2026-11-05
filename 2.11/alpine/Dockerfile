FROM alpine:3.24

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
	chmod 1777 /config/caddy /data/caddy; \
	wget -O /etc/caddy/Caddyfile "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/config/Caddyfile"; \
	wget -O /usr/share/caddy/index.html "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/welcome/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION=v2.11.9

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='0e85544340290a16ce4bfb76fe7d65e9de1bf3a6e67f5ccfff30b30d27ea4c73e078077b7bf3e58ae60b6b12e44327705287059c775bca5782e8ee85ea7edd75' ;; \
		armhf)   binArch='armv6'; checksum='bfd9b415660caccaf5efbba2a8828eb9e61e31609ee6a62d532e70ef1f419e2ba420fdfd1e16c13e4896c33557813f87fddc849de57400eac34c4635f413bc0c' ;; \
		armv7)   binArch='armv7'; checksum='ea042518bfb5eec5070a3119430263ae920b2d1e878c733a80d3d0ced1168afe5816362f295de46915d651a67f31f4d8a67ac67326f507d90cda71274b8ee689' ;; \
		aarch64) binArch='arm64'; checksum='9e5e76d7888542924de2c25353ae87c5f77e2a22c5b1198633cae13688922282e05383d142599205c88d8d80eee5e967d291214d7abce4835329a191b20dd6e0' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='9b95cfa058e9651c0738179c6c18d0a93eb9c491e5c9ed3d95f30b23e1c9324e739bbf91a3ac0ebf91aaff89e25de1cff22f127484be937c0089b079266cd37f' ;; \
		riscv64) binArch='riscv64'; checksum='52c9750b091a297766f2faaa01955eb894b614f4b94a9a418632d67f65f942e5363681869de0a6434d87482ac611f5c228282c23c6a90349085bb17aa3eff686' ;; \
		s390x)   binArch='s390x'; checksum='213186130eeab27bc8fff06f4a6cffb253b36f719166c6cb12c539b4432186d6f7938847547a4e5cf47b1525424fdc74813950f08b928f788b7402127eb30e6b' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.11.9/caddy_2.11.9_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+p /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

LABEL org.opencontainers.image.version=v2.11.9
LABEL org.opencontainers.image.title=Caddy
LABEL org.opencontainers.image.description="a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go"
LABEL org.opencontainers.image.url=https://caddyserver.com
LABEL org.opencontainers.image.documentation=https://caddyserver.com/docs
LABEL org.opencontainers.image.vendor="Light Code Labs"
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.source="https://github.com/caddyserver/caddy-docker"

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

WORKDIR /srv

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
