FROM golang:1.15-windowsservercore-1809

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV XCADDY_VERSION v0.1.5
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.2.0-rc.3
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

# Apparently Windows Server 2016 disables TLS 1.2 by default - this enables it so we can talk to GitHub
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/xcaddy/releases/download/v0.1.5/xcaddy_0.1.5_windows_amd64.zip" \
        -OutFile "/xcaddy.zip"; \
    if (!(Get-FileHash -Path /xcaddy.zip -Algorithm SHA512).Hash.ToLower().Equals('e63ceb91a6cd7ded39537d6a31970191a58b5b60b911ea39e7a9ab08e6d7d999e480fb01cab818eab9209b0e7a329539133510044712a3b9180464d5c0ddbdf4')) { exit 1; }; \
    Expand-Archive -Path "/xcaddy.zip" -DestinationPath "/" -Force; \
    Remove-Item "/xcaddy.zip" -Force

COPY caddy-builder.ps1 /caddy-builder.ps1
RUN New-Alias -Name caddy-builder -Value /caddy-builder.ps1

WORKDIR /
