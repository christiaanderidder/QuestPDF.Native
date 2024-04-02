FROM --platform=linux/amd64 mcr.microsoft.com/dotnet/sdk:8.0-alpine

# Install required build tools from apk
RUN apk add --no-cache \
    bash \
    curl \
    wget \
    python3 \
    git \
    build-base \
    ninja \
    fontconfig-dev \
    libintl \
    clang \
    cmake \
    gn \
    linux-headers

ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT 1

WORKDIR /work

# Clone skia and additional required build tools
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git ./depot_tools \
    && git clone https://github.com/google/skia.git --branch chrome/m124 --single-branch ./skia \
    && cd skia && python3 tools/git-sync-deps && cd ..

ENV PATH="${PATH}:/work/depot_tools"

# Copy QuestPDF.Native files
COPY . .

ENTRYPOINT ["/bin/bash", "./build.sh"]