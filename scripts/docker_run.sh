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
    -e "http_proxy=$http_proxy" \
    -e "FTP_PROXY=$FTP_PROXY" \
    -e "ftp_proxy=$ftp_proxy" \
    -e "HTTPS_PROXY=$HTTPS_PROXY" \
    -e "https_proxy=$https_proxy" \
    -e "no_proxy=$no_proxy" \
    -e "HTTP_PROXY=$HTTP_PROXY" \
    -v $LOCALDIR:/vol/scratch \
    -v $SPOOLDIR:/vol/spool \
    -v $MEMDISK:/vol/mem \
    asczyrba/kraken-hmp-os \
    $COMMAND


