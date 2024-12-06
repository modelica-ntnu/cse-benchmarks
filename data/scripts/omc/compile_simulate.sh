#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

nx=$1
ny=$2
nz=$3
solver=$4

fail() {
	rm -r "$BUILD_DIR"
	mkdir -p "$BUILD_DIR"
	exit 1
}

echo "nx=$nx, ny=$ny, nz=$nz, solver=$solver"

ulimit -s unlimited

echo "Compiling"
timeout $COMPILE_TIMEOUT "$path/compile.sh" $nx $ny $nz $solver || fail

echo "Simulating"
timeout $SIMULATE_TIMEOUT "$path/simulate.sh" $nx $ny $nz $solver || fail

echo "-----------------------------------"
echo ""
