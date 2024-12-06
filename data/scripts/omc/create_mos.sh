#!/bin/bash

n=$1
solver=$2
outfile=$3

echo "loadFile(\"$SRC_DIR/CityLight-$n.mo\");" > $outfile
cat script_base.mos >> $outfile
