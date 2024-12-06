#!/bin/bash
docker run --rm -ti -v ./data:/data -v ./marco:/tmp/marco-src -v ./output:/output marco-benchmarks
