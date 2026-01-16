FROM mcr.microsoft.com/windows/servercore:ltsc2022

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN mkdir /config; \
    mkdir /data; \
    mkdir /etc/caddy; \
    mkdir /usr/share/caddy; \
    Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/config/Caddyfile" \
        -OutFile "/etc/caddy/Caddyfile"; \
    Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/dist/raw/33ae08ff08d168572df2956ed14fbc4949880d94/welcome/index.html" \
        -OutFile "/usr/share/caddy/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION=v2.11.0-beta.2

RUN Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/caddy/releases/download/v2.11.0-beta.2/caddy_2.11.0-beta.2_windows_amd64.zip" \
        -OutFile "/caddy.zip"; \
    if (!(Get-FileHash -Path /caddy.zip -Algorithm SHA512).Hash.ToLower().Equals('90727e53aba2a140f2b2327b842ea05f656aae0c0a2322574eb7d0a5146ea48147066cb6fbdf24d4977a3d1464d965f01177fc9f2fca1f405a8d4b16312ceb9c')) { exit 1; }; \
    Expand-Archive -Path "/caddy.zip" -DestinationPath "/" -Force; \
    Remove-Item "/caddy.zip" -Force

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME=c:/config
ENV XDG_DATA_HOME=c:/data

LABEL org.opencontainers.image.version=v2.11.0-beta.2
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
