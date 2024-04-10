This project integrates [Skia](https://skia.org) and [QuestPDF](https://www.questpdf.com). It consists of two layers:
- Native unmanaged code - C++ wrapper for Skia that exposes and/or composes Skia APIs necessary for QuestPDF,
- Managed dotnet code - low-level wrapper using P/Invoke calls to access native code.

# Musl build
The docker commands below can be used to build QuestPDF.Native inside of an alpine docker container with musl.

## amd64 / x64
```zsh
docker build . --platform linux/amd64 -t questpdf:amd64
```

```zsh
docker run --rm -it \
--platform linux/amd64 \
-e QUESTPDF_RUNTIME=linux-x64 \
-v ./build.sh:/work/build.sh \
-v ./native/CMakeLists.txt:/work/native/CMakeLists.txt \
-v ./output-amd64:/work/output \
-v skia_release_amd64:/work/skia/out/release \
-v quest_release_amd64:/work/native/build \
questpdf:amd64
```

## arm64
```zsh
docker build . --platform linux/arm64 -t questpdf:arm64
```

```zsh
docker run --rm -it \
--platform linux/arm64 \
-e QUESTPDF_RUNTIME=linux-arm64 \
-v ./build.sh:/work/build.sh \
-v ./native/CMakeLists.txt:/work/native/CMakeLists.txt \
-v ./output-arm64:/work/output \
-v skia_release_arm64:/work/skia/out/release \
-v quest_release_arm64:/work/native/build \
questpdf:arm64
```