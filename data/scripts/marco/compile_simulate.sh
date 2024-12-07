#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

n=$1
solver=$2
cse=$3

echo "n=$n, solver=$solver, cse=$cse"

echo "Compiling"
timeout $COMPILE_TIMEOUT "$path/compile.sh" $n $solver $cse || exit 1

echo "Simulating"
timeout $SIMULATE_TIMEOUT "$path/simulate.sh" $n $solver $cse ${@:4} || exit 1

echo "-----------------------------------"
echo ""
