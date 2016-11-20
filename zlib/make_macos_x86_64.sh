#!/bin/bash

cwdir=`pwd`
rootdir=`dirname $0`
cd "$rootdir"
rootdir=`pwd`
target=macos_x86_64
prefix=$rootdir/$target
version=`cat $rootdir/version.txt`
rm -rf "$rootdir/$version"
mkdir "$rootdir/$version"
cp -rf "$rootdir/../$version/"* "$rootdir/$version"
rm -rf "$rootdir/project"
mkdir "$rootdir/project"
cd "$rootdir/project"
cmake -DBUILD64=ON -C "$rootdir/CMakeLists.txt" -DCMAKE_INSTALL_PREFIX="$prefix" "$rootdir/$version"
cmake "$rootdir/$version"
cmake --build . --target install --config Release --clean-first
mkdir "$rootdir/../target/include/$target"
cp -rf "$prefix/include/"* "$rootdir/../target/include/$target"
mkdir "$rootdir/../target/lib/$target"
cp -f "$prefix/lib/libz.a" "$rootdir/../target/lib/$target"
cd "$cwdir"
rm -rf "$rootdir/$version"
rm -rf "$rootdir/project"
rm -rf "$prefix"
