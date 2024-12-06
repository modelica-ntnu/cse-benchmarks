#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

n=$1
solver=$2
sim_args=${@:3}

"$path/compile_simulate.sh" $n $solver $sim_args 1> $LOG_DIR/log_$n-$solver.out 2> $LOG_DIR/log_$n-$solver.err
