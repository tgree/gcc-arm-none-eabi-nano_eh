# Copyright (c) 2022-2024 by Terry Greeniaus.
# Build with: docker build -t gcc-arm-none-eabi-13.3.rel1-nano_eh-build .
# Run with  : docker run -ti gcc-arm-none-eabi-13.3.rel1-nano_eh-build
FROM ubuntu:24.04

# Set the locale.
ENV LANG C.UTF-8

# Un-minimize to start with.
RUN yes | unminimize

# Make a download location in /tmp.
RUN mkdir /tmp/download-images

# Install gcc-arm-none-eabi sources.
ADD https://developer.arm.com/-/media/Files/downloads/gnu/13.3.rel1/srcrel/arm-gnu-toolchain-src-snapshot-13.3.rel1.tar.xz /tmp/download-images/

# Install the base OS and gcc build dependency packages.
RUN apt-get update                                      \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y   \
    bison                                               \
    flex                                                \
    g++                                                 \
    gcc                                                 \
    git                                                 \
    gzip                                                \
    m4                                                  \
    make                                                \
    python3                                             \
    python3-dev                                         \
    sudo                                                \
    texinfo                                             \
    vim                                                 \
    xz-utils                                            \
    zip

# Set up the gccbuild user.
COPY fs/home/userhome /home/gccbuild
RUN useradd -M -s /bin/bash gccbuild                    \
 && echo gccbuild:password | chpasswd                   \
 && adduser gccbuild sudo

# Move all downloads into the user's home directory.
RUN mv /tmp/download-images/* /home/gccbuild/           \
 && rmdir /tmp/download-images                          \
 && chown -R gccbuild:gccbuild /home/gccbuild

# Switch to the new user and set docker to execute all further commands out of the
# new user's home directory.
USER gccbuild
WORKDIR /home/gccbuild

# Clone the gnu-devtools-for-arm repository.
RUN mkdir src \
    && git clone -b gcc-arm-none-eabi-13.3.rel1-nano_eh https://github.com/tgree/gnu-devtools-for-arm-nano_eh.git src/gnu-devtools-for-arm \
    && ln -s src/gnu-devtools-for-arm/build-gnu-toolchain.sh

# Verify the MD5 sums on all downloaded files.  These should match the MD5
# sums listed on ARM's web site.  We embed the MD5 sum file taken from Arm's
# site to ensure that nothing is changed on us in the future without detecting
# it.
RUN md5sum -c arm-gnu-toolchain-src-snapshot-13.3.rel1.tar.xz.asc \
    && tar xf arm-gnu-toolchain-src-snapshot-13.3.rel1.tar.xz -C src/
