#!/bin/bash

path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

rm -rf "$path/marco"
mkdir -p "$path/marco"
git clone https://github.com/marco-compiler/marco.git "$path/marco"
cd "$path/marco"
git checkout arrangabriel/array-aware-call-cse
cd - &> /dev/null
