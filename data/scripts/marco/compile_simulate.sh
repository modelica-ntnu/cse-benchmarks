#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

n=$1
solver=$2

echo "n=$n, solver=$solver"

echo "Compiling"
timeout $COMPILE_TIMEOUT "$path/compile.sh" $n $solver || exit 1

echo "Simulating"
timeout $SIMULATE_TIMEOUT "$path/simulate.sh" $n $solver ${@:3} || exit 1

echo "-----------------------------------"
echo ""
