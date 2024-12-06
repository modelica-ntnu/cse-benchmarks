#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

n=$1
solver=$2

TIME_FILE=$LOG_DIR/simulation-time_$n-$solver.txt
/usr/bin/time -p -o $TIME_FILE "$path/simulation_run.sh" $BUILD_DIR CityLight.City || exit 1
mv "$BUILD_DIR/results.csv" "$RESULTS_DIR/results-$n-$solver.csv"
cat $TIME_FILE
