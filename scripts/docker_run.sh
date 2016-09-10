#!/bin/bash

if [ $# -ne 4 ]
  then
    echo 
    echo "Usage: docker_run.sh CONTAINER SCRATCHDIR SPOOLDIR COMMAND"
    echo 
    echo "script to submit docker array job"
    echo 
    echo "qsub -t 1-<num_tasks> -cwd docker_run.sh CONTAINER SCRATCHDIR SPOOLDIR COMMAND"
    echo 
    echo "sets  \$SCRATCHDIR:/vol/scratch"
    echo "      \$SPOOLDIR:/vol/spool"
    echo 
    echo "calls \"docker run COMMAND ...\""
    echo 
    exit 0;
fi

CONTAINER=$1
SCRATCHDIR=$2
SPOOLDIR=$3
COMMAND=$4

sudo docker pull $CONTAINER
sudo docker run \
    -e "NSLOTS=$NSLOTS" \
    -v $SCRATCHDIR:/vol/scratch \
    -v $SPOOLDIR:/vol/spool \
    $CONTAINER \
    $COMMAND


