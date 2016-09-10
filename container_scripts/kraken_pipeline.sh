#!/bin/bash

SCRATCHDIR=/vol/scratch
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

cd $SCRATCHDIR
echo "Downloading FASTQ File to $SCRATCHDIR..."
swift -U gcb:swift -K ssbBisjNkXmwgSXbvyAN6CtQJJcW2moMHEAdQVN0 -A http://swift:7480/auth download gcb $INFILE --output $SCRATCHDIR/$INFILE
echo "Done downloading FASTQ file."

cd $SPOOLDIR

OUTFILE="$SPOOLDIR/$OUTNAME.out"
REPORTFILE="$SPOOLDIR/$OUTNAME.report"

## run kraken
echo "running kraken:"
echo "/vol/kraken/kraken --preload --db $SCRATCHDIR --threads $NSLOTS --fastq-input --gzip-compressed --output $OUTFILE $SCRATCHDIR/$INFILE"
/vol/kraken/kraken --preload --db $SCRATCHDIR --threads $NSLOTS --fastq-input --gzip-compressed --output $OUTFILE $SCRATCHDIR/$INFILE
echo "kraken done."

## create reports
echo "creating Kraken report"
echo "/vol/kraken/kraken-report --db $SCRATCHDIR $OUTFILE > $REPORTFILE"
/vol/kraken/kraken-report --db $SCRATCHDIR $OUTFILE > $REPORTFILE
echo "Kraken report done"

#rm -v $OUTFILE
rm -v $SCRATCHDIR/$INFILE
