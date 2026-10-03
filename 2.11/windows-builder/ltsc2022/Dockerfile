FROM golang:1.27-windowsservercore-ltsc2022

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV XCADDY_VERSION=v0.4.7
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION=v2.11.7
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP=1

RUN Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/xcaddy/releases/download/v0.4.7/xcaddy_0.4.7_windows_amd64.zip" \
        -OutFile "/xcaddy.zip"; \
    if (!(Get-FileHash -Path /xcaddy.zip -Algorithm SHA512).Hash.ToLower().Equals('d39c613490286e68416285b495cbfc0cf955c6155561f9bee2d64fe9a95d46272d6123a69356c0246f8acf368b56fc6a941ffca511f170e843dca1d51192ba47')) { exit 1; }; \
    Expand-Archive -Path "/xcaddy.zip" -DestinationPath "/" -Force; \
    Remove-Item "/xcaddy.zip" -Force

WORKDIR /
