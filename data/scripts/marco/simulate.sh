#!/bin/bash

n=$1
solver=$2
sim_args=${@:3}

TIME_FILE=$LOG_DIR/simulation-time_$n-$solver.txt
/usr/bin/time -p -o $TIME_FILE $BUILD_DIR/simulation-$n-$solver $sim_args > $RESULTS_DIR/results-$n-$solver.csv
cat $TIME_FILE
