#!/bin/bash

# script to submit to qsub array job, that calls "docker run..."
# -> qsub -t 1-<num_tasks> -cwd docker_run.sh LOCALDIR SPOOLDIR COMMAND

if [ $# -ne 3 ]
  then
    echo "Usage: docker_run.sh LOCALDIR SPOOLDIR COMMAND"
    exit 0;
fi

LOCALDIR=$1
SPOOLDIR=$2
COMMAND=$3

sudo docker pull asczyrba/kraken-hmp
sudo docker run \
    -e "NSLOTS=$NSLOTS" \
    -v $LOCALDIR:/vol/scratch \
    -v $SPOOLDIR:/vol/spool \
    asczyrba/kraken-hmp \
    $COMMAND


