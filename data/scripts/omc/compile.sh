#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

n=$1
solver=$2

fail() {
	rm -rf "$BUILD_DIR"
	mkdir -p "$BUILD_DIR"
	exit 1
}

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

"$path/mos_builder_$solver.sh" $n $BUILD_DIR/script.mos $RESULTS_DIR/results_$n-$solver.csv
/usr/bin/time -p -o $LOG_DIR/omc-time_$n-$solver.txt "$path/run_mos.sh" $BUILD_DIR || fail

echo "Binary size: "
BINARY_SIZE_FILE=$LOG_DIR/omc-binary-size_$n-$solver.txt
wc -c $BUILD_DIR/CityLight.City > $BINARY_SIZE_FILE
cat $BINARY_SIZE_FILE

echo "C code size: "
C_SIZE_FILE=$LOG_DIR/omc-c-size_$n-$solver.txt
du -scb $BUILD_DIR/*.h $BUILD_DIR/*.c $BUILD_DIR/*.cpp | tail -n1 > $C_SIZE_FILE
cat $C_SIZE_FILE
