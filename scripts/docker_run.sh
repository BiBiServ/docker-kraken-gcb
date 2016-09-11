#!/bin/bash

if [ $# -ne 5 ]
  then
    echo 
    echo "Usage: docker_run.sh CONTAINER DBDIR DATADIR SPOOLDIR COMMAND"
    echo 
    echo "script to submit docker array job"
    echo 
    echo "qsub -t 1-<num_tasks> -cwd docker_run.sh CONTAINER DBDIR DATADIR SPOOLDIR COMMAND"
    echo 
    echo "sets  \$DBDIR:/vol/db"
    echo "      \$DATADIR:/vol/data"
    echo "      \$SPOOLDIR:/vol/spool"
    echo 
    echo "calls \"docker run COMMAND ...\""
    echo 
    exit 0;
fi

CONTAINER=$1
DBDIR=$2
DATADIR=$3
SPOOLDIR=$4
COMMAND=$5

sudo docker pull $CONTAINER
sudo docker run \
    -e "NSLOTS=$NSLOTS" \
    -v $DBDIR:/vol/db \
    -v $DATADIR:/vol/data \
    -v $SPOOLDIR:/vol/spool \
    $CONTAINER \
    $COMMAND


