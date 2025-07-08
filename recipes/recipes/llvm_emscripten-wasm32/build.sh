#!/bin/bash

set -eux
jjj
export BUILDDIR="_build_flang_llvm"

echo "🧿🧿🧿🧿🧿 CMaking"
cmake -S llvm -B $BUILDDIR -GNinja \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=$PREFIX \
        -DCMAKE_PREFIX_PATH=$PREFIX \
        -DCMAKE_SYSTEM_PREFIX_PATH=$PREFIX \
        -DLLVM_DEFAULT_TARGET_TRIPLE=wasm32-unknown-emscripten \
        -DLLVM_TARGETS_TO_BUILD=WebAssembly \
        -DLLVM_ENABLE_PROJECTS="clang;flang;mlir" \
        -DLLVM_BUILTIN_TARGETS="wasm32-unknown-emscripten" \
        -DCMAKE_CFLAGS="" \
        -DCMAKE_CXXFLAGS="" \
        -DCMAKE_VERBOSE_MAKEFILE=ON

echo "♥️♥️♥️♥️♥️ Building"
cmake --build $BUILDDIR -j6

echo "🔫🔫🔫🔫🔫 Installing"
cmake --build $BUILDDIR --target install