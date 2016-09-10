#!/bin/bash

# script to download the Mini-Kraken database to container directory /vol/scratch"

echo "Start downloading database..."

swift -U gcb:swift -K ssbBisjNkXmwgSXbvyAN6CtQJJcW2moMHEAdQVN0 -A http://swift:7480/auth \
download gcb minikraken.tgz --output /vol/scratch/minikraken.tgz

echo "done downloading database."

echo "extracting database files..."

cd /vol/scratch
tar xvzf minikraken.tgz
rm minikraken.tgz
echo "done extracting files."
