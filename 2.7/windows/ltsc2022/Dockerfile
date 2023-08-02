FROM mcr.microsoft.com/windows/servercore:ltsc2022

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN mkdir /config; \
    mkdir /data; \
    mkdir /etc/caddy; \
    mkdir /usr/share/caddy; \
    Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/dist/raw/5910351159c2995a9a1c911d7879de6ff598d905/config/Caddyfile" \
        -OutFile "/etc/caddy/Caddyfile"; \
    Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/dist/raw/5910351159c2995a9a1c911d7879de6ff598d905/welcome/index.html" \
        -OutFile "/usr/share/caddy/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.7.0

RUN Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/caddy/releases/download/v2.7.0/caddy_2.7.0_windows_amd64.zip" \
        -OutFile "/caddy.zip"; \
    if (!(Get-FileHash -Path /caddy.zip -Algorithm SHA512).Hash.ToLower().Equals('3cfe244947d65bfb95cab12657bfd07491d7745a210aacdf68adeffa9fb54824978d55c8854cbb4c82b75cb22f5b51ccf27c8dbce2d075f2aec223fa99d81a10')) { exit 1; }; \
    Expand-Archive -Path "/caddy.zip" -DestinationPath "/" -Force; \
    Remove-Item "/caddy.zip" -Force

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME c:/config
ENV XDG_DATA_HOME c:/data

LABEL org.opencontainers.image.version=v2.7.0
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

# Make sure it runs and reports its version
RUN ["caddy", "version"]

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
