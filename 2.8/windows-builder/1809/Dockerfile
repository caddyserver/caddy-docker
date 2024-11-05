FROM golang:1.23-windowsservercore-1809

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV XCADDY_VERSION v0.4.3
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.8.4
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/xcaddy/releases/download/v0.4.3/xcaddy_0.4.3_windows_amd64.zip" \
        -OutFile "/xcaddy.zip"; \
    if (!(Get-FileHash -Path /xcaddy.zip -Algorithm SHA512).Hash.ToLower().Equals('3d2cc64049cc056c51d4dd8be2f1b12e947c0e45a173aa4333815685373dc3c07c4c2ea438a8c9a33f0e0b1220552431394fdc2d966887a30f894bbca1a46128')) { exit 1; }; \
    Expand-Archive -Path "/xcaddy.zip" -DestinationPath "/" -Force; \
    Remove-Item "/xcaddy.zip" -Force

WORKDIR /
