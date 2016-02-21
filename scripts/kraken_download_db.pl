#!/usr/bin/env perl

use Getopt::Long;
use File::Path;
use File::Basename;
use Sys::Hostname;
use strict;

$ENV{PATH} = "$ENV{PATH}:/vol/scripts:/vol/krona/bin";

my ($krakendb, $krakendb_dir, $download_dir);


GetOptions("krakendb=s"     => \$krakendb,
	   "download_dir=s" => \$download_dir,
	   "dest=s"         => \$krakendb_dir
    );

unless ($krakendb && $krakendb_dir && $download_dir) {
    die "\nusage: $0 -krakendb KRAKEN_DB_S3_URL -download_dir TMP_DOWNLOAD_DIR -dest DESTINATION_DIR

Small example (4GB Kraken DB): 
$0 -krakendb s3://bibicloud-demo/kraken-db/minikraken_20140330.tar -download_dir /vol/scratch -dest /vol/mem/krakendb

Big example (80GB Kraken DB):
$0 -krakendb s3://bibicloud-demo/kraken-db/kraken_standard.tar -download_dir /vol/scratch -dest /vol/mem/krakendb
";
}

my $host = hostname;
mkpath($krakendb_dir);
mkpath($download_dir);
print STDERR "host: $host\n";

print STDERR "Downloading Database to $download_dir...\n";
#print STDERR "/vol/scripts/download.pl -type file -source $krakendb -dest $download_dir\n";
#system("/vol/scripts/download.pl -type file -source $krakendb -dest $download_dir");

print STDERR "java -jar /vol/scripts/bibis3-1.6.1.jar --region=eu-west-1 -d $krakendb $download_dir/\n";
system("java -jar /vol/scripts/bibis3-1.6.1.jar --region=eu-west-1 -d $krakendb $download_dir/");

chdir $krakendb_dir;
my $kraken_tarfile = basename($krakendb);
print STDERR "tar xvf $download_dir/$kraken_tarfile\n";
system("tar xvf $download_dir/$kraken_tarfile");
system("rm -v $download_dir/$kraken_tarfile");
print STDERR "Done downloading Database.\n";

