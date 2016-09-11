#!/bin/bash

DBDIR=/vol/db
DATADIR=/vol/data
SPOOLDIR=/vol/spool

if [ $# -ne 2 ]
  then
    echo 
    echo "Usage: kraken_pipeline.sh INFILE OUTNAME"
    echo 
    echo "Reportfile will be written to $SPOOLDIR/OUTNAME.report"
    echo
    exit 0;
fi

INFILE=$1
OUTNAME=$2

PATH=$PATH:/vol/scripts:/vol/krona/bin

cd $SPOOLDIR

OUTFILE="$SPOOLDIR/$OUTNAME.out"
REPORTFILE="$SPOOLDIR/$OUTNAME.report"

## run kraken
echo "running kraken:"
echo "/vol/kraken/kraken --preload --db $DBDIR --threads $NSLOTS --fastq-input --gzip-compressed --output $OUTFILE $DATADIR/$INFILE"
/vol/kraken/kraken --preload --db $DBDIR --threads $NSLOTS --fastq-input --gzip-compressed --output $OUTFILE $DATADIR/$INFILE
echo "kraken done."

## create reports
echo "creating Kraken report"
echo "/vol/kraken/kraken-report --db $DBDIR $OUTFILE > $REPORTFILE"
/vol/kraken/kraken-report --db $DBDIR $OUTFILE > $REPORTFILE
echo "Kraken report done"

