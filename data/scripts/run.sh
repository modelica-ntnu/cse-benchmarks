#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

rm -rf $BUILD_DIR
rm -rf $LOG_DIR
rm -rf $RESULTS_DIR

omc "$path/install_modelica_libs.mos"

"$path/marco/run.sh"
"$path/omc/run.sh"

echo "MARCO version"
marco --version

echo "OMC version"
omc --version

rm -rf $BUILD_DIR
date=$(date +%s)
tar -czvf /output/run-${date}.tar.gz $LOG_DIR $RESULTS_DIR &> /dev/null
csv_exporter $LOG_DIR euler-forward > /output/run-${date}-euler-forward.csv
