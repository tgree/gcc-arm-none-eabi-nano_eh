#!/bin/bash
# Notes:
#
#      In particular, the
#      configure parameter '--disable-libstdcxx-verbose' seems to be the
#      ingredient that avoids linking in all of the read()/write() and other
#      standard IO functions that spam your console when terminate() is
#      called.  We also need to remove the '--fno-exceptions'
#      CXXFLAGS_FOR_TARGET parameter so that we get exception tables in the
#      nano library builds.
#
# This takes around 110 minutes on my M1 Max Macbook Pro.
# This takes around 1100 minutes on my 2016 13-inch 4-port Macbook Pro.
GCC_VERSION=gcc-arm-none-eabi-13.3.rel1

# Exit when any command fails.
set -e

# Patch the official sources.
patch -p1 < ~/patches/gcc-libgloss-nano_eh-specs.patch

# Build it all.
time ./build-gnu-toolchain.sh --target=arm-none-eabi --aprofile --rmprofile -- --release --package --enable-newlib-nano --enable-gdb-with-python=yes

# Link and move final build products into place.
cd && mkdir -p pkg
mv build-arm-none-eabi/bin-tar/arm-none-eabi-tools.tar.xz pkg/$GCC_VERSION-nano-eh-`uname -m`-linux.tar.xz
echo Creating source tarball...
tar czf pkg/$GCC_VERSION-nano-eh-src.tgz -C src gcc
