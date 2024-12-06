#!/bin/bash
path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

export BUILD_DIR=$BUILD_DIR/omc
export LOG_DIR=$LOG_DIR/omc
export RESULTS_DIR=$RESULTS_DIR/omc

mkdir -p $BUILD_DIR
mkdir -p $LOG_DIR
mkdir -p $RESULTS_DIR

"$path/compile_simulate_all.sh" euler-forward
