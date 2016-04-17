#!/bin/bash

# script to submit to qsub array job, that calls "docker run..."
# -> qsub -t 1-<num_tasks> -cwd docker_run.sh LOCALDIR SPOOLDIR COMMAND

if [ $# -ne 4 ]
  then
    echo "Usage: docker_run.sh LOCALDIR SPOOLDIR MEMDISK COMMAND"
    exit 0;
fi

LOCALDIR=$1
SPOOLDIR=$2
MEMDISK=$3
COMMAND=$4

sudo docker pull asczyrba/kraken-hmp-os
sudo docker run \
    -e "NSLOTS=$NSLOTS" \
    -v $LOCALDIR:/vol/scratch \
    -v $SPOOLDIR:/vol/spool \
    -v $MEMDISK:/vol/mem \
    asczyrba/kraken-hmp-os \
    $COMMAND


