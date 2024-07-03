#!/bin/bash

set -xe

# get meson to find pkg-config when cross compiling
# export PKG_CONFIG=$BUILD_PREFIX/bin/pkg-config

# # need to find gobject-introspection-1.0 as a "native" (build) pkg-config dep
# # meson uses PKG_CONFIG_PATH to search when not cross-compiling and
# # PKG_CONFIG_PATH_FOR_BUILD when cross-compiling,
# # so add the build prefix pkgconfig path to the appropriate variables

# This is needed to find glib "native" for glib-mkenums
export PKG_CONFIG_PATH_FOR_BUILD=$BUILD_PREFIX/lib/pkgconfig
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$BUILD_PREFIX/lib/pkgconfig

# export XDG_DATA_DIRS=${XDG_DATA_DIRS}:$PREFIX/share

# meson_config_args=(
#     -Dintrospection=enabled
#     -Dfontconfig=enabled
#     -Dfreetype=enabled
#     -Ddocumentation=false
# )

# # ensure that the post install script is ignored
# export DESTDIR="/"

# printenv | grep WASM_BIGINT

# (
#     mkdir -p native-build

#     unset LDFLAGS # -sWASM_BIGINT is not supported by the native build

#     export CC=$(which gcc)
#     export CXX=$(which g++)
#     export OBJC=$(which gcc)
#     export AR="$($CC_FOR_BUILD -print-prog-name=ar)"
#     export NM="$($CC_FOR_BUILD -print-prog-name=nm)"
#     export LDFLAGS=${LDFLAGS//$PREFIX/$BUILD_PREFIX}
#     export PKG_CONFIG_PATH=${BUILD_PREFIX}/lib/pkgconfig

#     # Unset them as we're ok with builds that are either slow or non-portable
#     unset CFLAGS
#     unset CPPFLAGS
#     export host_alias=$build_alias
#     export PKG_CONFIG_PATH=$BUILD_PREFIX/lib/pkgconfig

#     meson setup native-build \
#         "${meson_config_args[@]}" \
#         --buildtype=release \
#         --prefix=$BUILD_PREFIX \
#         -Dlibdir=lib \
#         --wrap-mode=nofallback

#     # This script would generate the functions.txt and dump.xml and save them
#     # This is loaded in the native build. We assume that the functions exported
#     # by glib are the same for the native and cross builds
#     export GI_CROSS_LAUNCHER=$BUILD_PREFIX/libexec/gi-cross-launcher-save.sh
#     ninja -v -C native-build -j ${CPU_COUNT}
#     ninja -C native-build install -j ${CPU_COUNT}
# )
# export GI_CROSS_LAUNCHER=$BUILD_PREFIX/libexec/gi-cross-launcher-load.sh

meson_config_args=(
    -Dintrospection=disabled
    -Dfontconfig=enabled
    -Dfreetype=enabled
    -Dlibthai=disabled
    -Dxft=disabled
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


# export CFLAGS="$CFLAGS $(pkg-config --cflags glib-2.0, cairo, pixman-1, fribidi, freetype2, fontconfig, expat) -s USE_PTHREADS"
# export LDFLAGS="$LDFLAGS $(pkg-config --libs glib-2.0, cairo, pixman-1, fribidi, freetype2, fontconfig, expat) -lpthread"

# meson setup builddir \
#     --prefix=$PREFIX \
#     --cross-file=$RECIPE_DIR/emscripten.meson.cross \
#     --default-library=static \
#     --buildtype=release \
#     -Dintrospection=disabled

# meson install -C builddir
