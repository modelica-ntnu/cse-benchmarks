#!/bin/bash

"$path/marco_clone.sh"
"$path/docker_upgrade.sh"
"$path/docker_build.sh"
mkdir -p "$path/output"

docker run --rm \
	-v "$path/data":/data \
	-v "$path/marco":/tmp/marco-src \
	-v "$path/output":/output \
	-e COMPILE_TIMEOUT=1200 \
	-e SIMULATE_TIMEOUT=3600 \
	marco-benchmarks \
	bash -c "/data/run.sh"
