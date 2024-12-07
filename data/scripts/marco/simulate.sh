#!/bin/bash

n=$1
solver=$2
cse=$3
sim_args=${@:4}

TIME_FILE=$LOG_DIR/simulation-time_$n-$solver-$cse.txt
/usr/bin/time -p -o $TIME_FILE $BUILD_DIR/simulation-$n-$solver-$cse $sim_args > $RESULTS_DIR/results-$n-$solver-$cse.csv
cat $TIME_FILE
