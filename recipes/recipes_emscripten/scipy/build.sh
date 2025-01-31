#!/bin/bash

set -ex

# Using flang as a WASM cross-compiler
# https://github.com/serge-sans-paille/llvm-project/blob/feature/flang-wasm/README.wasm.md
# https://github.com/conda-forge/flang-feedstock/pull/69
micromamba install -p $BUILD_PREFIX \
    conda-forge/label/llvm_rc::libllvm19=19.1.0.rc2 \
    conda-forge/label/llvm_dev::flang=19.1.0.rc2 \
    -y --no-channel-priority
rm $BUILD_PREFIX/bin/clang # links to clang19
ln -s $BUILD_PREFIX/bin/clang-18 $BUILD_PREFIX/bin/clang # links to emsdk clang

export FC=flang-new
export FFLAGS="-g --target=wasm32-unknown-emscripten"

mkdir builddir

meson setup builddir \
    "${meson_config_args[@]}" \
    --buildtype=release \
    --default-library=static \
    --prefer-static \
    --prefix=$PREFIX \
    -Dlibdir=lib \
    -Dfortran_std=none \
    --wrap-mode=nofallback \
    --cross-file=$RECIPE_DIR/emscripten.meson.cross

# -wnx flags mean: --wheel --no-isolation --skip-dependency-check
$PYTHON -m build -w -n -x \
    -Cbuilddir=builddir \
    -Cinstall-args=--tags=runtime,python-runtime,devel \
    -Csetup-args=-Dblas=blas \
    -Csetup-args=-Dlapack=lapack \
    -Csetup-args=-Duse-g77-abi=true \
    -Csetup-args=${MESON_ARGS// / -Csetup-args=}

# # copy complete folder scipy to side-packages
# mkdir -p $PREFIX/lib/python3.11/site-packages
# cp -r scipy $PREFIX/lib/python3.11/site-packages
# cp -r scipy-1.11.1.dist-info $PREFIX/lib/python3.11/site-packages