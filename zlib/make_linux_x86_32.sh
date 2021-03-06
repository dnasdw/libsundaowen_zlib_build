#!/bin/bash

pushd "`dirname "$0"`"
rootdir=`pwd`
tmpdir=/tmp/libsundaowen_zlib
target=linux_x86_32
prefix=$tmpdir/$target
version=`cat version.txt`
rm -rf "$tmpdir/$version"
mkdir -p "$tmpdir/$version"
cp -rf "../$version/"* "$tmpdir/$version"
pushd "$tmpdir/$version"
rm -rf build
mkdir build
cd build
cmake -DBUILD64=OFF -C "$rootdir/CMakeLists.txt" -DCMAKE_INSTALL_PREFIX="$prefix" ..
cmake --build . --target install --config Release --clean-first
popd
mkdir -p "../target/include/$target"
cp -rf "$prefix/include/"* "../target/include/$target"
mkdir -p "../target/lib/$target"
cp -f "$prefix/lib/"*.a "../target/lib/$target"
popd
rm -rf "$tmpdir"
