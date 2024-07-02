#/bin/bash

set -ex

# export LDFLAGS="${LDFLAGS} -sUSE_FREETYPE=1 -sUSE_PTHREADS=0"
# export PTHREAD_CFLAGS=" "

# # delete this file (is excluded in webr)
# rm ./src/fcobjshash.h

# mkdir build && cd build

# emconfigure ../configure \
#     ac_cv_func_fstatfs=no \
#     ac_cv_func_link=no \
#     --enable-shared=no \
#     --enable-static=yes \
#     --enable-expat \
#     --prefix=$PREFIX

# emmake make RUN_FC_CACHE_TEST=false install

# # Copy .wasm $PREFIX/bin/ files also
# cp fc-cache/fc-cache.wasm $PREFIX/bin/
# cp fc-cat/fc-cat.wasm $PREFIX/bin/
# cp fc-list/fc-list.wasm $PREFIX/bin/
# cp fc-match/fc-match.wasm $PREFIX/bin/
# cp fc-pattern/fc-pattern.wasm $PREFIX/bin/
# cp fc-query/fc-query.wasm $PREFIX/bin/
# cp fc-scan/fc-scan.wasm $PREFIX/bin/
# cp fc-validate/fc-validate.wasm $PREFIX/bin/


# Propagate -pthread into CFLAGS to ensure it is compiled with the
# atomics/bulk-memory features
CFLAGS="$CFLAGS -pthread"

meson_setup_args=(
    -Dtests=disabled
    -Ddefault_library=static
    -Dnls=disabled
    -Dcache-build=disabled
    -Ddoc=disabled
    -Dtools=disabled
)

meson setup builddir \
    ${meson_setup_args[@]} \
    --prefix=$PREFIX \
    --buildtype=release \
    --prefer-static \
    --cross-file=$RECIPE_DIR/emscripten.meson.cross

meson install -C builddir
