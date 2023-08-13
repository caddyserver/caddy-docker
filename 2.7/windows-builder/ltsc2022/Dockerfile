FROM golang:1.20-windowsservercore-ltsc2022

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV XCADDY_VERSION v0.3.4
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.7.3
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/xcaddy/releases/download/v0.3.4/xcaddy_0.3.4_windows_amd64.zip" \
        -OutFile "/xcaddy.zip"; \
    if (!(Get-FileHash -Path /xcaddy.zip -Algorithm SHA512).Hash.ToLower().Equals('542b4c083852d41081186c79757b66ff3c26248f72ed461dbc038b51687d0a8a8ce8eee69e3b5a1d43360c48b3405b611b940fa378debe98aaa0b3c5aebfa218')) { exit 1; }; \
    Expand-Archive -Path "/xcaddy.zip" -DestinationPath "/" -Force; \
    Remove-Item "/xcaddy.zip" -Force

WORKDIR /
