#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

n=$1
solver=$2

NUM_RUNS=10
OMC_FLAGS="--baseModelica --newBackend -d=evaluateAllParameters"
VAR_FILTER="bigHouses.brightHouses.power;bigHouses.almostBrightHouses.power;bigHouses.almostDarkHouses.power;bigHouses.darkHouses.power;smallHouses.brightHouses.power;smallHouses.almostBrightHouses.power;smallHouses.almostDarkHouses.power;smallHouses.darkHouses.power"

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "---------------------------------------------"
echo "Compile tool for time statistics"
g++ "$path/time_stat.cpp" -o $BUILD_DIR/time_stat

echo "---------------------------------------------"
echo "Compile tool for size statistics"
g++ "$path/size_stat.cpp" -o $BUILD_DIR/size_stat

echo "---------------------------------------------"
echo "Generate Base Modelica"
OMC_TIMES_FILE=$BUILD_DIR/omc-times_$n-$solver.txt

for ((i = 0; i <= $NUM_RUNS; i++))
do
	/usr/bin/time -p -a -o $OMC_TIMES_FILE omc $SRC_DIR/CityLight-$n.mo -i=CityLight.City $OMC_FLAGS &> /dev/null
done

omc $SRC_DIR/CityLight-$n.mo -i=CityLight.City $OMC_FLAGS 1> $BUILD_DIR/CityLight-flat-$n.mo

echo "---------------------------------------------"
echo "Computing Base Modelica generation time"
echo "Base Modelica generation time:"
OMC_TIME_FILE=$LOG_DIR/omc-time_$n-solver.txt
$BUILD_DIR/time_stat $OMC_TIMES_FILE > $OMC_TIME_FILE
cat $OMC_TIME_FILE

echo "---------------------------------------------"
echo "Fix Base Modelica"

cp $BUILD_DIR/CityLight-flat-$n.mo $BUILD_DIR/CityLight-flat-fixed-$n.mo
sed -i '1,2d;$d' $BUILD_DIR/CityLight-flat-fixed-$n.mo

echo "---------------------------------------------"
echo "Generating code sizes"
MODELICA_DIALECT_SIZES_FILE=$LOG_DIR/bmodelica-sizes_$n-$solver.txt
LLVMIR_SIZES_FILE=$LOG_DIR/llvmir-sizes_$n-$solver.txt

for ((i = 0; i <= $NUM_RUNS; i++))
do
marco \
  -mc1 \
  -no-multithreading \
  $BUILD_DIR/CityLight-flat-fixed-$n.mo \
  --omc-bypass \
  --model=City \
  --solver=$solver \
  -emit-mlir -O2 \
  --variables-filter="$VAR_FILTER" \
  -o $BUILD_DIR/model.mlir

wc -c $BUILD_DIR/model.mlir >> $MODELICA_DIALECT_SIZES_FILE

marco \
  $BUILD_DIR/CityLight-flat-fixed-$n.mo \
  -Xmarco -no-multithreading \
  --omc-bypass \
  --model=City \
  --solver=$solver \
  -c -emit-llvm -O2 \
  --variables-filter="$VAR_FILTER" \
  -o $BUILD_DIR/model.bc

llvm-dis $BUILD_DIR/model.bc -o $BUILD_DIR/model.ll
wc -c $BUILD_DIR/model.ll >> $LLVMIR_SIZES_FILE
done

echo "---------------------------------------------"
echo "Computing code sizes"
echo "------"
echo "Modelica dialect size:"
MODELICA_DIALECT_SIZE_FILE=$LOG_DIR/bmodelica-size_$n-$solver.txt
$BUILD_DIR/size_stat $MODELICA_DIALECT_SIZES_FILE > $MODELICA_DIALECT_SIZE_FILE
cat $MODELICA_DIALECT_SIZE_FILE

echo "------"
echo "LLVM-IR size:"
LLVMIR_SIZE_FILE=$LOG_DIR/llvmir-size_$n-$solver.txt
$BUILD_DIR/size_stat $LLVMIR_SIZES_FILE > $LLVMIR_SIZE_FILE
cat $LLVMIR_SIZE_FILE

echo "---------------------------------------------"
echo "Build simulation"
MARCO_COMPILE_TIMES_FILE=$LOG_DIR/marco-compile-times_$n-$solver.txt

for ((i = 0; i <= $NUM_RUNS; i++))
do
/usr/bin/time -p -a -o $MARCO_COMPILE_TIMES_FILE marco \
  $BUILD_DIR/CityLight-flat-fixed-$n.mo \
  -Xmarco -no-multithreading \
  -Xmarco -no-equations-runtime-scheduling \
  --omc-bypass -O2 \
  --model=ThermalChipSimpleBoundary \
  --solver=$solver \
  -o $BUILD_DIR/simulation-$n-$solver \
  --variables-filter="$VAR_FILTER"
done

echo "---------------------------------------------"
echo "MARCO build time:"
MARCO_COMPILE_TIME_FILE=$LOG_DIR/marco-compile-time_$n-$solver.txt
$BUILD_DIR/time_stat $MARCO_COMPILE_TIMES_FILE > $MARCO_COMPILE_TIME_FILE
cat $MARCO_COMPILE_TIME_FILE

echo "---------------------------------------------"
echo "Binary size:"
MARCO_BINARY_SIZE_FILE=$LOG_DIR/marco-binary-size_$n-$solver.txt
wc -c $BUILD_DIR/simulation-$n-$solver > $MARCO_BINARY_SIZE_FILE
cat $MARCO_BINARY_SIZE_FILE
