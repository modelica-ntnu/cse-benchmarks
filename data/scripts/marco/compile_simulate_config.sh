#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

n=$1
solver=$2
cse=$3
sim_args=${@:4}

"$path/compile_simulate.sh" $n $solver $cse $sim_args 1> $LOG_DIR/log_$n-$solver-$cse.out 2> $LOG_DIR/log_$n-$solver-$cse.err
