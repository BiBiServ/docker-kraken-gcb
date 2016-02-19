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

print STDERR "Downloading FASTQ File to /vol/scratch/...\n";
print STDERR "/vol/scripts/download.pl -type file -source $infile -dest /vol/scratch\n";
system("/vol/scripts/download.pl -type file -source $infile -dest /vol/scratch");
print STDERR "Done downloading FASTQ file.\n";

chdir("/vol/scratch");
my $bz2file = basename($infile);
print STDERR "extracting file $bz2file...\n";
system("tar xvjf $bz2file");
print STDERR "extracting done.\n";

chdir "/vol/spool";

my $outfile = "$outdir/$jobname.out";
## run kraken
print STDERR "running kraken:\n";
print STDERR "/vol/kraken/kraken --preload --db $krakendb_dir --threads $threads --fastq-input --output $outfile --paired `ls /vol/scratch/$jobname/$jobname.*[12].fastq`\n";
system("/vol/kraken/kraken --preload --db $krakendb_dir --threads $threads --fastq-input --output $outfile --paired `ls /vol/scratch/$jobname/$jobname.*[12].fastq`");
print STDERR "kraken done.\n";

## create reports
print STDERR "creating Kraken report:\n";
print STDERR "/vol/kraken/kraken-report --db $krakendb_dir $outfile > $outfile.report\n";
system("/vol/kraken/kraken-report --db $krakendb_dir $outfile > $outfile.report");
print STDERR "Kraken report done.\n";

chdir("/vol/scratch");
system("rm -v $bz2file");
system("rm -rfv $jobname");

