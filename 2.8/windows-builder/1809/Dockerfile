FROM golang:1.22-windowsservercore-1809

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV XCADDY_VERSION v0.4.1
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.8.0-rc.1
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/xcaddy/releases/download/v0.4.1/xcaddy_0.4.1_windows_amd64.zip" \
        -OutFile "/xcaddy.zip"; \
    if (!(Get-FileHash -Path /xcaddy.zip -Algorithm SHA512).Hash.ToLower().Equals('b058280b1e15e0915c541bc8a3aefc2289155c38a9fbc2f8d6b05267f9d0469eae5be2a9312d52c5ba41c7dbcb18c0970efa5b1df628655cca81b55d5c51d9e1')) { exit 1; }; \
    Expand-Archive -Path "/xcaddy.zip" -DestinationPath "/" -Force; \
    Remove-Item "/xcaddy.zip" -Force

WORKDIR /
