#!/bin/bash
path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

export BUILD_DIR=$BUILD_DIR/marco
export LOG_DIR=$LOG_DIR/marco
export RESULTS_DIR=$RESULTS_DIR/marco

mkdir -p $BUILD_DIR
mkdir -p $LOG_DIR
mkdir -p $RESULTS_DIR

"$path/compile_simulate_all.sh" euler-forward --time-step=1440 --end-time=86400
