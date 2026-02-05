FROM golang:1.26rc3-windowsservercore-ltsc2022

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV XCADDY_VERSION=v0.4.5
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION=v2.11.0-beta.2
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP=1

RUN Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/xcaddy/releases/download/v0.4.5/xcaddy_0.4.5_windows_amd64.zip" \
        -OutFile "/xcaddy.zip"; \
    if (!(Get-FileHash -Path /xcaddy.zip -Algorithm SHA512).Hash.ToLower().Equals('652857d019f3e1772b154b33f2479d8f17f4b10818802363737d35601c4cd51dc9a9ba0b3c64cdada9fe6bdcebb4395d0561b2ca302ae1219b288758c01911c1')) { exit 1; }; \
    Expand-Archive -Path "/xcaddy.zip" -DestinationPath "/" -Force; \
    Remove-Item "/xcaddy.zip" -Force

WORKDIR /
