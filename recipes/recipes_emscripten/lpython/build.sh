#!/usr/bin/env bash

set -e
set -x

mkdir -p src/bin/asset_dir
cp src/runtime/*.py src/bin/asset_dir
cp -r src/runtime/lpython src/bin/asset_dir

emcmake cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_FLAGS_RELEASE="-Wall -Wextra -fexceptions" \
    -DWITH_LLVM=no \
    -DLPYTHON_BUILD_ALL=no \
    -DLPYTHON_BUILD_TO_WASM=yes \
    -DWITH_STACKTRACE=no \
    -DWITH_LSP=no \
    -DWITH_LFORTRAN_BINARY_MODFILES=no \
    -DCMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH_LFORTRAN;$CONDA_PREFIX" \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    .

# Build step
emmake make -j${CPU_COUNT}

# Install step
emmake make install

# Copy tests
cp src/lpython/tests/test_lpython.js $PREFIX/bin/test_lpython.js
cp src/lpython/tests/test_lpython.wasm $PREFIX/bin/test_lpython.wasm
