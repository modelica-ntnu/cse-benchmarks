#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

solver=$1
sim_args=${@:2}

"$path/compile_simulate_config.sh" 4 $solver || exit 1
"$path/compile_simulate_config.sh" 8 $solver || exit 1
"$path/compile_simulate_config.sh" 16 $solver || exit 1
"$path/compile_simulate_config.sh" 32 $solver || exit 1
"$path/compile_simulate_config.sh" 64 $solver || exit 1
"$path/compile_simulate_config.sh" 128 $solver || exit 1
"$path/compile_simulate_config.sh" 256 $solver || exit 1
"$path/compile_simulate_config.sh" 512 $solver || exit 1
"$path/compile_simulate_config.sh" 1024 $solver || exit 1
"$path/compile_simulate_config.sh" 2048 $solver || exit 1
"$path/compile_simulate_config.sh" 4096 $solver || exit 1
"$path/compile_simulate_config.sh" 8192 $solver || exit 1
"$path/compile_simulate_config.sh" 16384 $solver || exit 1
"$path/compile_simulate_config.sh" 32768 $solver || exit 1
"$path/compile_simulate_config.sh" 65536 $solver || exit 1
"$path/compile_simulate_config.sh" 131072 $solver || exit 1
"$path/compile_simulate_config.sh" 262144 $solver || exit 1
#"$path/compile_simulate_config.sh" 524288 $solver || exit 1
#"$path/compile_simulate_config.sh" 1048576 $solver || exit 1
#"$path/compile_simulate_config.sh" 2097152 $solver || exit 1
#"$path/compile_simulate_config.sh" 4194304 $solver || exit 1
#"$path/compile_simulate_config.sh" 8388608 $solver || exit 1
