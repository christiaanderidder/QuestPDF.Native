#!/usr/bin/env bash

set -e # Exit on error

pushd skia

#    skia_use_system_icu=false
COMMON_ARGS='
    is_official_build=true
    is_component_build=false
    is_debug=false
    skia_enable_optimize_size=true
    skia_enable_tools=true
    skia_use_system_expat=false
    skia_use_system_harfbuzz=false
    skia_use_system_libjpeg_turbo=false
    skia_use_system_libpng=false
    skia_use_system_libwebp=false
    skia_use_system_zlib=false
    skia_use_system_freetype2=false
    skia_use_dng_sdk=false
    skia_use_harfbuzz=true
    skia_use_icu=false
    skia_use_icu4x=false
    skia_use_libgrapheme=true
    skia_use_fontconfig=false
    skia_use_gl=false
    skia_use_libjpeg_turbo_decode=true
    skia_use_libjpeg_turbo_encode=true
    skia_use_libpng_encode=true
    skia_use_libpng_decode=true
    skia_use_libwebp_encode=true
    skia_use_libwebp_decode=true
    skia_enable_android_utils=false
    skia_enable_spirv_validation=false
    skia_enable_gpu=false
    skia_enable_gpu_debug_layers=false
    skia_use_jpeg_gainmaps=false
    skia_use_libheif=false
    skia_use_lua=false
    skia_enable_svg=true
    skia_use_expat=true
    skia_enable_skshaper=true
    skia_enable_skunicode=true
    skia_pdf_subset_harfbuzz=true
    skia_enable_pdf=true
    skia_compile_modules=true
    extra_cflags=["-fPIC", "-fno-rtti"]
'

echo $'\n********** Running gn **********\n'

gn gen out/release --args="$COMMON_ARGS"

echo $'\n********** Running ninja **********\n'

# Fix -nopie argument, change to correct -no-pie
sed -i -e 's/-nopie/-no-pie/g' ./gn/skia/BUILD.gn
ninja -C out/release skia svg skparagraph

popd

echo $'\n********** Building QuestPDF native **********\n'

cmake \
    -S ${PWD}/native \
    -B ${PWD}/native/build \
    -DSKIA_DIR=${PWD}/skia \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_BUILD_TYPE=Release

cmake \
    --build ${PWD}/native/build \
    --config Release

RUNTIME=linux-amd64

mkdir -p output/runtimes/$RUNTIME/native
find native/build -type f \( -name "*.dylib" -o -name "*.dll" -o -name "*.so" \) -exec cp {} output/runtimes/$RUNTIME/native \;

echo $'\n********** Building QuestPDF managed **********\n'

dotnet build managed --configuration Debug --framework net8.0
cp -R output/* managed/NativeSkia.Tests/bin/Debug/net8.0
dotnet test managed --framework net8.0
mkdir -p testOutput/$RUNTIME
cp -r managed/NativeSkia.Tests/bin/Debug/net8.0/Output/* testOutput/$RUNTIME