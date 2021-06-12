FROM golang:1.16-windowsservercore-ltsc2016

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV XCADDY_VERSION v0.1.9
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.4.2
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

# Apparently Windows Server 2016 disables TLS 1.2 by default - this enables it so we can talk to GitHub
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/xcaddy/releases/download/v0.1.9/xcaddy_0.1.9_windows_amd64.zip" \
        -OutFile "/xcaddy.zip"; \
    if (!(Get-FileHash -Path /xcaddy.zip -Algorithm SHA512).Hash.ToLower().Equals('8d5cf4479e471d47fd067ce2fbe34c2015a96caedab95ca042aeb633956cbc2bb89c1bc4fe6593c1f96ca58bc66b21f32caa6b099122b9d500a3902245fa5105')) { exit 1; }; \
    Expand-Archive -Path "/xcaddy.zip" -DestinationPath "/" -Force; \
    Remove-Item "/xcaddy.zip" -Force

WORKDIR /
