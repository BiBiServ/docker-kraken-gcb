#!/bin/sh

if [ $# -ne 8 ]
  then
    echo "Usage: $0 SLOTS KRAKENDB JOBNAME S3_HMP_DATASET AWS_REGION OUTDIR TMPDIR MEMDISK"
    echo
    echo "Example: $0 8 /vol/mem/krakendb SRS015996 s3://human-microbiome-project/HHS/HMASM/WGS/anterior_nares/SRS015996.tar.bz2 us-west-2 /vol/spool /vol/scratch /dev/shm"
    exit 1
fi

SLOTS=$1
KRAKENDB=$2
JOBNAME=$3
BZ2FILE=$4
AWS_REGION=$5
OUTDIR=$6
SCRATCHDIR=$7
MEMDISK=$8

PIPELINEHOME=`dirname $0`

export PATH=$PIPELINEHOME/krona/bin:$PATH

echo $PIPELINEHOME

echo "Submitting job to SGE..."
echo qsub -cwd -pe multislot $SLOTS $PIPELINEHOME/docker_run.sh $SCRATCHDIR $OUTDIR $MEMDISK "/vol/scripts/kraken_pipeline.pl -krakendb $KRAKENDB -infile $BZ2FILE -aws_region $AWS_REGION -outdir $OUTDIR -tmpdir $SCRATCHDIR -jobname $JOBNAME"
qsub -N $JOBNAME -cwd -pe multislot $SLOTS $PIPELINEHOME/docker_run.sh $SCRATCHDIR $OUTDIR $MEMDISK "/vol/scripts/kraken_pipeline.pl -krakendb $KRAKENDB -infile $BZ2FILE -aws_region $AWS_REGION -outdir $OUTDIR -tmpdir $SCRATCHDIR -jobname $JOBNAME"

exit
## combine Kraken output and convert
echo "combining Kraken outputs"
echo "$PIPELINEHOME/scripts/kraken_to_txt.py $OUTDIR $OUTDIR/kraken_output.combined n"
$PIPELINEHOME/scripts/kraken_to_txt.py $OUTDIR $OUTDIR/kraken_output.combined n
echo "DONE combining Kraken outputs"

## create Krona file
echo "creating KRONA file:"
echo "$PIPELINEHOME/krona/bin/ktImportText -o kraken_krona.html $OUTDIR/kraken_output.combined"
$PIPELINEHOME/krona/bin/ktImportText -o $OUTDIR/kraken_krona.html $OUTDIR/kraken_output.combined
echo "KRONA report done."

echo "PIPELINE FINISHED."

