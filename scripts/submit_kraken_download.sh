#!/bin/sh

if [ $# -ne 8 ]
  then
    echo "Usage: $0 SLOTS NUM_NODES SCRATCHDIR SPOOLDIR MEMDISK KRAKENDB AWS_REGION KRAKENDB_DIR"
    echo
    echo "Example: $0 8 2 /vol/scratch /vol/spool /dev/shm s3://bibicloud-demo/kraken-db/minikraken_20140330.tar eu-west-1 /vol/mem/krakendb"
    exit 1
fi

SLOTS=$1
NUM_NODES=$2
SCRATCHDIR=$3
SPOOLDIR=$4
MEMDISK=$5
KRAKENDB=$6
AWS_REGION=$7
KRAKENDB_DIR=$8

PIPELINEHOME=`dirname $0`

echo "Submitting job to SGE and waiting until finished..."
echo qsub -V -cwd -t 1-$NUM_NODES -pe multislot $SLOTS $PIPELINEHOME/docker_run.sh $SCRATCHDIR $SPOOLDIR $MEMDISK "/vol/scripts/kraken_download_db.pl -krakendb $KRAKENDB -aws_region $AWS_REGION -download_dir $SCRATCHDIR -dest $KRAKENDB_DIR"
qsub -cwd -V -N KrakenDB_download -t 1-$NUM_NODES -pe multislot $SLOTS $PIPELINEHOME/docker_run.sh $SCRATCHDIR $SPOOLDIR $MEMDISK "/vol/scripts/kraken_download_db.pl -krakendb $KRAKENDB -aws_region $AWS_REGION -download_dir $SCRATCHDIR -dest $KRAKENDB_DIR"

