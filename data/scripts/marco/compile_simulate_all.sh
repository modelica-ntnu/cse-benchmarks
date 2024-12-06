#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

solver=$1
sim_args=${@:2}

"$path/compile_simulate_config.sh" 4 $solver $sim_args
"$path/compile_simulate_config.sh" 8 $solver $sim_args
"$path/compile_simulate_config.sh" 16 $solver $sim_args
"$path/compile_simulate_config.sh" 32 $solver $sim_args
"$path/compile_simulate_config.sh" 64 $solver $sim_args
"$path/compile_simulate_config.sh" 128 $solver $sim_args
"$path/compile_simulate_config.sh" 256 $solver $sim_args
"$path/compile_simulate_config.sh" 512 $solver $sim_args
"$path/compile_simulate_config.sh" 1024 $solver $sim_args
"$path/compile_simulate_config.sh" 2048 $solver $sim_args
"$path/compile_simulate_config.sh" 4096 $solver $sim_args
"$path/compile_simulate_config.sh" 8192 $solver $sim_args
"$path/compile_simulate_config.sh" 16384 $solver $sim_args
"$path/compile_simulate_config.sh" 32768 $solver $sim_args
"$path/compile_simulate_config.sh" 65536 $solver $sim_args
"$path/compile_simulate_config.sh" 131072 $solver $sim_args
"$path/compile_simulate_config.sh" 262144 $solver $sim_args
"$path/compile_simulate_config.sh" 524288 $solver $sim_args
"$path/compile_simulate_config.sh" 1048576 $solver $sim_args
"$path/compile_simulate_config.sh" 2097152 $solver $sim_args
"$path/compile_simulate_config.sh" 4194304 $solver $sim_args
"$path/compile_simulate_config.sh" 8388608 $solver $sim_args
