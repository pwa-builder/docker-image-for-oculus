ARG REPO=mcr.microsoft.com/dotnet/aspnet
FROM $REPO:6.0.1-focal-amd64

ENV \
    # Unset ASPNETCORE_URLS from aspnet base image
    ASPNETCORE_URLS= \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Do not show first run text
    DOTNET_NOLOGO=true \
    # SDK version
    DOTNET_SDK_VERSION=6.0.101 \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Unset Logging__Console__FormatterName from aspnet base image
    Logging__Console__FormatterName= \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Ubuntu-20.04 \
    JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/

# RUN apt-get update \
#     && apt-get install -y --no-install-recommends \
#     curl \
#     git \
#     wget \
#     && rm -rf /var/lib/apt/lists/* 


RUN  apt-get update  -y \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:openjdk-r/ppa \
    && apt-get install -y openjdk-11-jdk \
    && apt-get install -y curl \
    && apt-get install unzip


# Install .NET SDK
RUN curl -fSL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz \
    && dotnet_sha512='ca21345400bcaceadad6327345f5364e858059cfcbc1759f05d7df7701fec26f1ead297b6928afa01e46db6f84e50770c673146a10b9ff71e4c7f7bc76fbf709' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./packs ./sdk ./sdk-manifests ./templates ./LICENSE.txt ./ThirdPartyNotices.txt \
    && rm dotnet.tar.gz \
    && rm -rf /var/lib/apt/lists/* \
    # Trigger first run experience by running arbitrary cmd
    && dotnet help \
    && echo java -version





