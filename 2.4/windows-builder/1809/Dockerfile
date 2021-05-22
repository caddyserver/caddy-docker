FROM golang:1.16-windowsservercore-1809

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV XCADDY_VERSION v0.1.9
# Configures xcaddy to build with this version of Caddy
ENV CADDY_VERSION v2.4.1
# Configures xcaddy to not clean up post-build (unnecessary in a container)
ENV XCADDY_SKIP_CLEANUP 1

# Apparently Windows Server 2016 disables TLS 1.2 by default - this enables it so we can talk to GitHub
RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest \
        -Uri "https://github.com/caddyserver/xcaddy/releases/download/v0.1.9/xcaddy_0.1.9_windows_amd64.zip" \
        -OutFile "/xcaddy.zip"; \
    if (!(Get-FileHash -Path /xcaddy.zip -Algorithm SHA512).Hash.ToLower().Equals('d03d5f6e22cc1c7dfbfd7ca0946a1c313e6b7cf24eb846b4a732452445cede8ec1a3caff6d78b4ba6a47f8dfcfc85d989beb1165e5b74c230eabb0d20a3c6379')) { exit 1; }; \
    Expand-Archive -Path "/xcaddy.zip" -DestinationPath "/" -Force; \
    Remove-Item "/xcaddy.zip" -Force

WORKDIR /
