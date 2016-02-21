#!/usr/bin/env perl

use Getopt::Long;
use File::Path;
use File::Basename;
use Sys::Hostname;
use strict;


$ENV{PATH} = "$ENV{PATH}:/vol/scripts:/vol/krona/bin";

my ($infile, $outdir, $jobname, $krakendb_dir);


GetOptions("infile=s"       => \$infile,
	   "outdir=s"       => \$outdir,
	   "jobname=s"      => \$jobname,
	   "krakendb=s"     => \$krakendb_dir
    );

my $threads = $ENV{"NSLOTS"};

unless ($infile && $outdir && $jobname && $krakendb_dir) {
    die "\nusage: $0 -infile S3_HMP_BZ2 -jobname JOBNAME -outdir OUTDIR -krakendb KRAKEN_DB_S3_URL

Example:
$0 -krakendb /vol/scratch/krakendb -infile s3://human-microbiome-project/HHS/HMASM/WGS/anterior_nares/SRS015996.tar.bz2 -jobname SRS015996 -outdir /vol/spool

";
}

my $host = hostname;

print STDERR "host: $host\n";

chdir "/vol/spool";
my $outfile = "$outdir/$jobname.out";
my $reportfile = "$outdir/$jobname.report";

## create reports
print STDERR "creating Kraken report:\n";
print STDERR "/vol/kraken/kraken-report --db $krakendb_dir $outfile > $reportfile\n";
system("/vol/kraken/kraken-report --db $krakendb_dir $outfile > $reportfile");
print STDERR "Kraken report done.\n";
