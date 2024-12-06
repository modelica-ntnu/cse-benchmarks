#!/bin/bash

rm -rf /tmp/marco-build
mkdir /tmp/marco-build

cmake \
  -S /tmp/marco-src -B /tmp/marco-build -G Ninja \
  -DCMAKE_LINKER_TYPE=MOLD \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/root/install/marco

cmake --build /tmp/marco-build --target install
rm -rf /tmp/marco-build
