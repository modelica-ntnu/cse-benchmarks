#!/bin/bash

echo "Building csv_exporter"

rm -rf /tmp/csv_exporter-build
mkdir /tmp/csv_exporter-build

rm -rf /root/install/csv_exporter
mkdir /root/install/csv_exporter

cmake -S /tmp/csv_exporter-src -B /tmp/csv_exporter-build -DCMAKE_INSTALL_PREFIX=/root/install/csv_exporter
cmake --build /tmp/csv_exporter-build --target install
