# emconfigure ./configure \
#     --enable-shared=no \
#     --enable-static=yes \
#     --with-threads=no \
#     --with-pcre=internal \
#     --disable-libmount \
#     --prefix=${PREFIX}

# emmake make install


meson_config_args=(
    -Dlibdir=lib
    -Dlibmount=disabled
    -Dselinux=disabled
    -Dlibelf=disabled
    -Dxattr=false
    -Dtests=false
)

# meson --buildtype=release --prefix="$PREFIX" --backend=ninja -Dlibdir=lib \
#       -Diconv=external -Dlibmount=disabled -Dselinux=disabled -Dxattr=false ..
# ninja -j${CPU_COUNT} -v


meson setup builddir \
    ${MESON_ARGS} \
    "${meson_config_args[@]}" \
    --buildtype=release \
    --backend=ninja \
    --debug \
    --default-library=static \
    --prefix=$PREFIX \
    --wrap-mode=nofallback \
    --cross-file=$RECIPE_DIR/emscripten.meson.cross
ninja -v -C builddir -j ${CPU_COUNT}
ninja -C builddir install -j ${CPU_COUNT}
