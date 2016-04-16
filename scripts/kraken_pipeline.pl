#!/usr/bin/env perl

use Getopt::Long;
use File::Path;
use File::Basename;
use Sys::Hostname;
use strict;


$ENV{PATH} = "$ENV{PATH}:/vol/scripts:/vol/krona/bin";

my ($infile, $aws_region, $outdir, $jobname, $krakendb_dir, $tmpdir);


GetOptions("infile=s"       => \$infile,
	   "aws_region=s"   => \$aws_region,
	   "tmpdir=s"       => \$tmpdir,
	   "outdir=s"       => \$outdir,
	   "jobname=s"      => \$jobname,
	   "krakendb=s"     => \$krakendb_dir
    );

my $threads = $ENV{"NSLOTS"};

unless ($infile && $aws_region && $outdir && $jobname && $krakendb_dir && $tmpdir) {
    die "\nusage: $0 -infile S3_HMP_BZ2 -aws_region AWS_REGION -jobname JOBNAME -outdir OUTDIR -tmpdir TMPDIR -krakendb KRAKEN_DB_S3_URL

Example:
$0 -krakendb /vol/scratch/krakendb -infile s3://human-microbiome-project/HHS/HMASM/WGS/anterior_nares/SRS015996.tar.bz2 -aws_region us-west-2 -jobname SRS015996 -outdir /vol/spool -tmpdir /vol/scratch

";
}

my $host = hostname;

print STDERR "host: $host\n";

print STDERR "Downloading FASTQ File to /vol/scratch/...\n";
print STDERR "/vol/scripts/download.pl -type file -source $infile -aws_region $aws_region -dest /vol/scratch\n";
system("/vol/scripts/download.pl -type file -source $infile -aws_region $aws_region -dest /vol/scratch");
print STDERR "Done downloading FASTQ file.\n";

chdir("/vol/scratch");
my $bz2file = basename($infile);
print STDERR "extracting file $bz2file...\n";
system("lbzip2 -n $threads -cd $bz2file | tar xvf -");
print STDERR "extracting done.\n";
print "FASTQ file sizes:\n";
system("ls -l $jobname");
system("rm -v $bz2file");

chdir "/vol/spool";

my $outfile = "$tmpdir/$jobname.out";
my $reportfile = "$outdir/$jobname.report";

## run kraken
print STDERR "running kraken:\n";
#print STDERR "/vol/kraken/kraken --preload --db $krakendb_dir --threads $threads --fastq-input --output $outfile --paired `ls /vol/scratch/$jobname/$jobname.*[12].fastq`\n";
#system("/vol/kraken/kraken --preload --db $krakendb_dir --threads $threads --fastq-input --output $outfile --paired `ls /vol/scratch/$jobname/$jobname.*[12].fastq`");
print STDERR "/vol/kraken/kraken --preload --db $krakendb_dir --threads $threads --fastq-input --output $outfile `ls /vol/scratch/$jobname/$jobname.*[12].fastq`\n";
system("/vol/kraken/kraken --preload --db $krakendb_dir --threads $threads --fastq-input --output $outfile `ls /vol/scratch/$jobname/$jobname.*[12].fastq`");
print STDERR "kraken done.\n";

## create reports
print STDERR "creating Kraken report:\n";
print STDERR "/vol/kraken/kraken-report --db $krakendb_dir $outfile > $reportfile\n";
system("/vol/kraken/kraken-report --db $krakendb_dir $outfile > $reportfile");
print STDERR "Kraken report done.\n";
system("rm -rfv $outfile");

chdir("/vol/scratch");
system("rm -rfv $jobname");



chdir "/vol/spool";
my $outfile = "$outdir/$jobname.out";


