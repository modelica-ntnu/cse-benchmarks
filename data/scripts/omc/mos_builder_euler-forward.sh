#!/bin/bash

n=$1
outfile=$2
resultsfile=$3

echo "loadFile(\"$SRC_DIR/CityLight-$n.mo\");" > $outfile
echo "getErrorString();" >> $outfile
echo "buildModel(" >> $outfile
echo "    CityLight.City," >> $outfile
echo "    method=\"euler\"," >> $outfile
echo "    stopTime=86400," >> $outfile
echo "    numberOfIntervals=1440," >> $outfile
echo "    outputFormat=\"csv\"," >> $outfile
echo "    variableFilter=\"bigHouses.brightHouses.power|bigHouses.almostBrightHouses.power|bigHouses.almostDarkHouses.power|bigHouses.darkHouses.power|smallHouses.brightHouses.power|smallHouses.almostBrightHouses.power|smallHouses.almostDarkHouses.power|smallHouses.darkHouses.power\"," >> $outfile
echo "    cflags=\"-O0\"," >> $outfile
echo "    simflags=\"-lv=LOG_STATS_V -r=\\\"results.csv\\\"\");" >> $outfile
echo "getErrorString();" >> $outfile
