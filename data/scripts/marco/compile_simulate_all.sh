#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

solver=$1
cse=$2
sim_args=${@:3}

"$path/compile_simulate_config.sh" 4 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 8 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 16 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 32 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 64 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 128 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 256 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 512 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 1024 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 2048 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 4096 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 8192 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 16384 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 32768 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 65536 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 131072 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 262144 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 524288 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 1048576 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 2097152 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 4194304 $solver $cse $sim_args
"$path/compile_simulate_config.sh" 8388608 $solver $cse $sim_args
