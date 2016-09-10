#!/bin/bash

if [ $# -ne 1 ]
  then
    echo 
    echo "Usage: $0 SCRATCHDIR"
    echo 
    echo "script to download the Mini-Kraken database to SCRATCHDIR"
    echo 
    exit 0;
fi

SCRATCHDIR=$1

echo "Start downloading database..."

swift -U gcb:swift -K ssbBisjNkXmwgSXbvyAN6CtQJJcW2moMHEAdQVN0 -A http://swift:7480/auth \
download gcb minikraken.tgz --output $SCRATCHDIR/minikraken.tgz

echo "done downloading database."

echo "extracting database files..."

cd $SCRATCHDIR
tar xvzf $SCRATCHDIR

echo "done extracting files.
