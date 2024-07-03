#!/bin/bash

set -ex

export CFLAGS="-s USE_PTHREADS"
LDFLAGS="$LDFLAGS -lpthread"

meson_config_args=(
    -Dfontconfig=enabled
    -Dfreetype=enabled
    -Dglib=enabled
    -Dpng=disabled
    -Dxlib=disabled
    -Dxlib-xcb=disabled
    -Dxcb=disabled
    -Dspectre=disabled
    -Dtests=disabled
    -Dgtk2-utils=disabled
    -Dzlib=enabled # because: error --shared-memory is disallowed by sfnt.c.o
)

meson setup builddir \
    ${MESON_ARGS} \
    "${meson_config_args[@]}" \
    --buildtype=release \
    --default-library=static \
    --prefer-static \
    --prefix=$PREFIX \
    --wrap-mode=nofallback \
    --cross-file=$RECIPE_DIR/emscripten.meson.cross

meson install -C builddir
