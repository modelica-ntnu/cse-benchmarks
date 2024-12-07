#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

"$path/marco_clone.sh"
"$path/apptainer_build.sh"
mkdir -p "$path/output"
mkdir -p "$path/root"

apptainer exec \
	--bind "$path/data":/data \
	--bind "$path/marco":/tmp/marco-src \
	--bind "$path/output":/output \
	--bind "$path/root":/root \
	--env COMPILE_TIMEOUT=7200 \
	--env SIMULATE_TIMEOUT=7200 \
	marco-benchmarks.sif \
	bash -c /data/run.sh
