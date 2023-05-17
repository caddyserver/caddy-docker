FROM golang:1.20-windowsservercore-1809

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV XCADDY_VERSION v0.3.3
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.7.0-beta.1
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

RUN Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/xcaddy/releases/download/v0.3.3/xcaddy_0.3.3_windows_amd64.zip" \
        -OutFile "/xcaddy.zip"; \
    if (!(Get-FileHash -Path /xcaddy.zip -Algorithm SHA512).Hash.ToLower().Equals('9ebb94cf9e30c3763d95ee0f1b7ac6eddf3ac6b622cc693a220099752fa7ca30bdb55be450f9b7ceca4c7e903df2e8120436791dfb6cf504d88b2a7e23af5132')) { exit 1; }; \
    Expand-Archive -Path "/xcaddy.zip" -DestinationPath "/" -Force; \
    Remove-Item "/xcaddy.zip" -Force

WORKDIR /
