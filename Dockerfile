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



# FROM ubuntu:20.04


# ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# # nodejs version
# ENV NODE_VERSION="12.x"

# # Set locale
# ENV LANG="en_US.UTF-8" \
#     LANGUAGE="en_US.UTF-8" \
#     LC_ALL="en_US.UTF-8"

# RUN apt-get clean && apt-get update -qq && apt-get install -qq -y apt-utils locales && locale-gen $LANG

# ENV DEBIAN_FRONTEND="noninteractive" \
#     TERM=dumb \
#     DEBIAN_FRONTEND=noninteractive \
#     ASPNETCORE_URLS= \
#     # Do not generate certificate
#     DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
#     # Do not show first run text
#     DOTNET_NOLOGO=true \
#     # SDK version
#     DOTNET_SDK_VERSION=6.0.101 \
#     # Enable correct mode for dotnet watch (only mode supported in a container)
#     DOTNET_USE_POLLING_FILE_WATCHER=true \
#     # Unset Logging__Console__FormatterName from aspnet base image
#     Logging__Console__FormatterName= \
#     # Skip extraction of XML docs - generally not useful within an image/container - helps performance
#     NUGET_XMLDOC_MODE=skip \
#     # PowerShell telemetry for docker image usage
#     POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetSDK-Ubuntu-20.04

# # Variables must be references after they are created

# COPY README.md /README.md

# WORKDIR /tmp

# # Installing packages
# RUN apt-get update -qq > /dev/null && \
#     apt-get install -qq --no-install-recommends \
#     build-essential \
#     curl \
#     git \ 
#     # openjdk-8-jdk \
#     # openssh-client \
#     # pkg-config \
#     unzip \
#     wget \
#     zip 




# # Install .NET SDK
# RUN curl -fSL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz -k  \
#     && mkdir -p /usr/share/dotnet \
#     && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz ./packs ./sdk ./sdk-manifests ./templates ./LICENSE.txt ./ThirdPartyNotices.txt \
#     && rm dotnet.tar.gz 


# RUN dotnet --help
# # Trigger first run experience by running arbitrary cmd



# # # Install PowerShell global tool
# # RUN powershell_version=7.2.1 \
# # && curl -fSL --output PowerShell.Linux.x64.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Linux.x64.$powershell_version.nupkg \
# # && powershell_sha512='bfd0fac3fe5e905156d28433dbf4978d5cea69a4f1b63cb5b8d903f865f0febf4a1b0476a5b84a8e3509b354c44b0cd9e79b31a105176f03b90693ff51c7bb0b' \
# # && echo "$powershell_sha512  PowerShell.Linux.x64.$powershell_version.nupkg" | sha512sum -c - \
# # && mkdir -p /usr/share/powershell \
# # && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $powershell_version PowerShell.Linux.x64 \
# # && dotnet nuget locals all --clear \
# # && rm PowerShell.Linux.x64.$powershell_version.nupkg \
# # && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
# # && chmod 755 /usr/share/powershell/pwsh \
# # # To reduce image size, remove the copy nupkg that nuget keeps.
# # && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm



