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
ENV CADDY_VERSION=v2.11.8

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='c863699eee84c6b410573de2ec67af81d07eb054f9020bb98f3c6cb256fea4be2fd1acfbd39110c649c3338282593bba3d3ed6424d91b7f5675e8b877a8999e9' ;; \
		armhf)   binArch='armv6'; checksum='92f8653268e3eb412bdf57211b1c4c153f20da44f56f4bed73b3009b7fc288ea098f104fe55ade7226eee9bc53d4628c8e53e96fef06b10004a9a3489333a7f1' ;; \
		armv7)   binArch='armv7'; checksum='e9b6f8aa0fa9b12ee7b875b5105ee4835d1c7d83ea574583d54150e340b757d4cb78157e32215dc7a820f60ecd8507cd3b2169e81e79c09954f3b91ae59c2b6e' ;; \
		aarch64) binArch='arm64'; checksum='6a285426268c8f987e0c459f61dc5af3c25e663955c0e4dddc6e187722b7cdd15e4233ff0e570a4ee17b3c68d59e2a61ce96d2f6be55ea58eead6a334859557c' ;; \
		ppc64el|ppc64le) binArch='ppc64le'; checksum='a037e51b3a7d2f4f97a19e1df8e284b7f850773dfffebd80c3aede45b29f82c6b82ba9604a258e0ac9af77b7185b1ce7819bc7033e35339f6b830d80f4761096' ;; \
		riscv64) binArch='riscv64'; checksum='5b90fc0b8a509a7320375e03203b70e454488cbefc7e46acc7d877fe1635b1753ee0b33516fd3bb4c46b5c33d7976ceb38ed42b1470112efdfe0c9479b10458a' ;; \
		s390x)   binArch='s390x'; checksum='ed65138dffbc9c1437d399e7b7c5b277c1b6eb909cb61a0b1f5f2cda32ec95ecf52c2a510cb9f068bb23b242cdd9809f019cbb59e8a78a77d630e35160c49514' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/v2.11.8/caddy_2.11.8_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+p /usr/bin/caddy; \
	chmod +x /usr/bin/caddy; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=/config
ENV XDG_DATA_HOME=/data

LABEL org.opencontainers.image.version=v2.11.8
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
