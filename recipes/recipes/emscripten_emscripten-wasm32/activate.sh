if [ -z ${CONDA_FORGE_EMSCRIPTEN_ACTIVATED+x} ]; then

    export EM_OLD_LDFLAGS=$LDFLAGS
    export EM_OLD_CFLAGS=$CFLAGS


    export CONDA_FORGE_EMSCRIPTEN_ACTIVATED=1

    if [ -z ${BUILD_PREFIX+x} ]; then
        export EMSDK_PYTHON=${CONDA_PREFIX}/bin/python3
        export PYTHON=${CONDA_PREFIX}/bin/python3
    else
        export EMSDK_PYTHON=${BUILD_PREFIX}/bin/python3
        export PYTHON=${BUILD_PREFIX}/bin/python3
    fi

    CONDA_EMSDK_DIR=$CONDA_PREFIX/opt/emsdk
 
    export EMSCRIPTEN_VERSION=$PKG_VERSION
    export EMSCRIPTEN_FORGE_EMSDK_DIR=$CONDA_EMSDK_DIR

    # clear all prexisting cmake args / CC / CXX / AR / RANLIB
    export CC="emcc"
    export CXX="em++"
    export AR="emar"
    export RANLIB="emranlib"
    
    export CMAKE_ARGS=""

    # set the emscripten toolchain
    export CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=$CONDA_EMSDK_DIR/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake"

    # conda prefix path
    export CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_PREFIX_PATH=$PREFIX"

    # install prefix
    export CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=$PREFIX"

    # find root path mode package
    export CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ON"

    # fpic
    export CMAKE_ARGS="$CMAKE_ARGS -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=true"

    cmake () {
        emcmake cmake "$@"
    }


    # basics
    export EM_FORGE_OPTFLAGS="-O2"
    export EM_FORGE_DBGFLAGS="-g0"

    # basics ld
    export EM_FORGE_LDFLAGS_BASE="-s WASM=1 -sWASM_BIGINT -L${PREFIX}/lib"
    export EM_FORGE_LDFLAGS_BASE="${EM_FORGE_OPTFLAGS} ${EM_FORGE_DBGFLAGS} ${EM_FORGE_LDFLAGS_BASE}"

    # basics cflags
    export EM_FORGE_CFLAGS_BASE="-fPIC"
    export EM_FORGE_CFLAGS_BASE="${EM_FORGE_OPTFLAGS} ${EM_FORGE_DBGFLAGS} ${EM_FORGE_CFLAGS_BASE}"

    # side module
    export EM_FORGE_SIDE_MODULE_LDFLAGS="${EM_FORGE_LDFLAGS_BASE} -s SIDE_MODULE=1"
    export EM_FORGE_SIDE_MODULE_CFLAGS="${EM_FORGE_CFLAGS_BASE} -I${PREFIX}/include"


    export LDFLAGS="${EM_FORGE_LDFLAGS_BASE} ${LDFLAGS}"
    export CFLAGS="${EM_FORGE_CFLAGS_BASE} ${CFLAGS}"

fi