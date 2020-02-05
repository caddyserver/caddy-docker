FROM golang:1.13.6-alpine as builder

WORKDIR /src

RUN apk add --no-cache \
    git \
    ca-certificates

ARG CADDY_SOURCE_VERSION=v2.0.0-beta.13

RUN git clone -b $CADDY_SOURCE_VERSION https://github.com/caddyserver/caddy.git --single-branch

WORKDIR /src/caddy/cmd/caddy

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -trimpath -tags netgo -ldflags '-extldflags "-static" -s -w' -o /usr/bin/caddy

# Fetch the latest default welcome page and default Caddy config
FROM alpine:3.11.3 AS fetch-assets

RUN apk add --no-cache git

ARG DIST_COMMIT=4d5728e7a4452d31030336c8e3ad9a006e58af18

WORKDIR /src/dist
RUN git clone https://github.com/caddyserver/dist .
RUN git checkout $DIST_COMMIT

RUN cp config/Caddyfile /Caddyfile
RUN cp welcome/index.html /index.html

FROM alpine:3.11.3 AS alpine

RUN addgroup -S caddy \
    && adduser -SD -h /var/lib/caddy/ -g 'Caddy web server' -s /sbin/nologin -G caddy caddy

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs

COPY --from=fetch-assets /Caddyfile /etc/caddy/Caddyfile
COPY --from=fetch-assets /index.html /usr/share/caddy/index.html

ARG VCS_REF
ARG VERSION
LABEL org.opencontainers.image.revision=$VCS_REF
LABEL org.opencontainers.image.version=$VERSION
LABEL org.opencontainers.image.title=Caddy
LABEL org.opencontainers.image.description="a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go"
LABEL org.opencontainers.image.url=https://caddyserver.com
LABEL org.opencontainers.image.documentation=https://github.com/caddyserver/caddy/wiki/v2:-Documentation
LABEL org.opencontainers.image.vendor="Light Code Labs"
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.source="https://github.com/caddyserver/caddy-docker"

EXPOSE 8080
EXPOSE 2019

USER caddy

RUN mkdir -p /var/lib/caddy/.local/share/caddy
VOLUME /var/lib/caddy/.local/share/caddy

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]

FROM scratch AS scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs
COPY --from=alpine /etc/passwd /etc/passwd
COPY --from=alpine /etc/group /etc/group
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=alpine --chown=caddy:caddy /var/lib/caddy /var/lib/caddy

COPY --from=fetch-assets /Caddyfile /etc/caddy/Caddyfile
COPY --from=fetch-assets /index.html /usr/share/caddy/index.html

ARG VCS_REF
ARG VERSION
LABEL org.opencontainers.image.revision=$VCS_REF
LABEL org.opencontainers.image.version=$VERSION
LABEL org.opencontainers.image.title=Caddy
LABEL org.opencontainers.image.description="a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go"
LABEL org.opencontainers.image.url=https://caddyserver.com
LABEL org.opencontainers.image.documentation=https://github.com/caddyserver/caddy/wiki/v2:-Documentation
LABEL org.opencontainers.image.vendor="Light Code Labs"
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.source="https://github.com/caddyserver/caddy-docker"

EXPOSE 8080
EXPOSE 2019

USER caddy

VOLUME /var/lib/caddy/.local/share/caddy

ENTRYPOINT ["caddy"]
CMD ["run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
