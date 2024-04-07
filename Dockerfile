FROM alpine:latest

# Install required build tools from apk
# gn installs ninja as dependency
RUN apk add --no-cache \
    bash \
    wget \
    git \
    python3 \
    build-base \
    cmake \
    icu-libs \
    linux-headers \
    bsd-compat-headers \
    gn

WORKDIR /work

# Install .NET SDK
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh \
    && chmod +x ./dotnet-install.sh \
    && ./dotnet-install.sh --channel 8.0

# Clone skia and additional required build tools
RUN git clone https://github.com/google/skia.git --branch chrome/m124 --single-branch ./skia \
    && cd skia \
    && python3 tools/git-sync-deps \
    && cd ..

ENV QUESTPDF_RUNTIME=linux-arm64
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
ENV PATH="${PATH}:/root/.dotnet"

# Copy QuestPDF.Native files
COPY . .

ENTRYPOINT ["/bin/bash", "./build.sh"]