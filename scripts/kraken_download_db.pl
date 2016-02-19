#!/usr/bin/env perl

use Getopt::Long;
use File::Path;
use File::Basename;
use Sys::Hostname;
use strict;

$ENV{PATH} = "$ENV{PATH}:/vol/scripts:/vol/krona/bin";

my ($krakendb, $krakendb_dir);


GetOptions("krakendb=s"     => \$krakendb,
	   "dest=s"         => \$krakendb_dir
    );

unless ($krakendb && $krakendb_dir) {
    die "\nusage: $0 -krakendb KRAKEN_DB_S3_URL -dest DESTINATION_DIR

Small example (4GB Kraken DB): 
$0 -krakendb s3://bibicloud-demo/kraken-db/minikraken_20140330.tar -dest /vol/scratch/krakendb

Big example (142GB Kraken DB):
$0 -krakendb s3://bibicloud-demo/kraken-db/kraken_standard.tar -dest /vol/scratch/krakendb
";
}

my $host = hostname;
mkpath($krakendb_dir);
print STDERR "host: $host\n";

print STDERR "Downloading Database to $krakendb_dir...\n";
print STDERR "/vol/scripts/download.pl -type file -source $krakendb -dest $krakendb_dir\n";
system("/vol/scripts/download.pl -type file -source $krakendb -dest $krakendb_dir");
chdir $krakendb_dir;
my $kraken_tarfile = basename($krakendb);
print STDERR "tar xvf $kraken_tarfile\n";
system("tar xvf $kraken_tarfile");
print STDERR "Done downloading Database.\n";

