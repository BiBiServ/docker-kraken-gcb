#!/bin/sh

if [ $# -ne 6 ]
  then
    echo "Usage: $0 SLOTS NUM_NODES SCRATCHDIR SPOOLDIR KRAKENDB KRAKENDB_DIR"
    echo
    echo "Example: $0 8 2 /vol/scratch /vol/spool s3://bibicloud-demo/kraken-db/minikraken_20140330.tar /vol/scratch/krakendb"
    exit 1
fi

SLOTS=$1
NUM_NODES=$2
SCRATCHDIR=$3
SPOOLDIR=$4
KRAKENDB=$5
KRAKENDB_DIR=$6

PIPELINEHOME=`dirname $0`

echo "Submitting job to SGE and waiting until finished..."
echo qsub -cwd -t 1-$NUM_NODES -pe multislot $SLOTS $PIPELINEHOME/docker_run.sh $SCRATCHDIR $SPOOLDIR "/vol/scripts/kraken_download_db.pl -krakendb $KRAKENDB -dest $KRAKENDB_DIR"
qsub -cwd -N KrakenDB_download -t 1-$NUM_NODES -pe multislot $SLOTS $PIPELINEHOME/docker_run.sh $SCRATCHDIR $SPOOLDIR "/vol/scripts/kraken_download_db.pl -krakendb $KRAKENDB -dest $KRAKENDB_DIR"

