FROM mcr.microsoft.com/windows/servercore:ltsc2016

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Apparently Windows Server 2016 disables TLS 1.2 by default - this enables it so we can talk to GitHub
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    mkdir /config; \
    mkdir /data; \
    mkdir /etc/caddy; \
    mkdir /usr/share/caddy; \
    Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/dist/raw/a8ef04588bf34a9523b76794d601c6e9cb8e31d3/config/Caddyfile" \
        -OutFile "/etc/caddy/Caddyfile"; \
    Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/dist/raw/a8ef04588bf34a9523b76794d601c6e9cb8e31d3/welcome/index.html" \
        -OutFile "/usr/share/caddy/index.html"

# https://github.com/caddyserver/caddy/releases
ENV CADDY_VERSION v2.4.3

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/caddy/releases/download/v2.4.3/caddy_2.4.3_windows_amd64.zip" \
        -OutFile "/caddy.zip"; \
    if (!(Get-FileHash -Path /caddy.zip -Algorithm SHA512).Hash.ToLower().Equals('e4b392d1384a02863f93c0e183c50a2b28a19ccf468c186fa1524b041895c237dbb88b0dd20c13d187779c0b5f5789458c84ffbc17cd628a9fd05779eb418563')) { exit 1; }; \
    Expand-Archive -Path "/caddy.zip" -DestinationPath "/" -Force; \
    Remove-Item "/caddy.zip" -Force

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME c:/config
ENV XDG_DATA_HOME c:/data

VOLUME c:/config
VOLUME c:/data

LABEL org.opencontainers.image.version=v2.4.3
LABEL org.opencontainers.image.title=Caddy
LABEL org.opencontainers.image.description="a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go"
LABEL org.opencontainers.image.url=https://caddyserver.com
LABEL org.opencontainers.image.documentation=https://caddyserver.com/docs
LABEL org.opencontainers.image.vendor="Light Code Labs"
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.source="https://github.com/caddyserver/caddy-docker"

EXPOSE 80
EXPOSE 443
EXPOSE 2019

# Make sure it runs and reports its version
RUN ["caddy", "version"]

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
