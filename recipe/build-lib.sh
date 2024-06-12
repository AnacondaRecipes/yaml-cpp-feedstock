#!/bin/bash

if [[ "${PKG_NAME}" == *static ]]; then
    SHARED="OFF"
else
    SHARED="ON"
fi

# Generate the build files.
cmake -B "build-${PKG_NAME}/" \
    -G Ninja \
    -D BUILD_SHARED_LIBS="${SHARED}" \
    -D YAML_BUILD_SHARED_LIBS="${SHARED}"  \
    -D YAML_CPP_BUILD_TESTS=ON \
    -D CMAKE_BUILD_TYPE=Release \
    -D CMAKE_PREFIX_PATH=$PREFIX \
    -D CMAKE_INSTALL_PREFIX=$PREFIX \
    ${CMAKE_ARGS}

cmake --build "build-${PKG_NAME}/" --parallel ${CPU_COUNT} --verbose
cmake --install "build-${PKG_NAME}/"

# Call author's tests.
build-${PKG_NAME}/test/yaml-cpp-tests

rm -v $PREFIX/lib/libgmock*
rm -v $PREFIX/lib/libgtest*
