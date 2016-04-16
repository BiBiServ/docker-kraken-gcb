#!/usr/bin/env perl

use Getopt::Long;
use strict;

my ($type, $source, $aws_region, $dest, $grid_nodes, $current_node);
my $bibis3call;
my $bibis3bin = '/vol/scripts/bibis3-1.6.1.jar';

GetOptions("type=s"         => \$type,
	   "source=s"       => \$source,
	   "aws_region=s"   => \$aws_region,
	   "dest=s"         => \$dest,
	   "grid-nodes:i"   => \$grid_nodes,
	   "current-node:i" => \$current_node,
    );

unless ($type && $source && $aws_region && $dest) {
    die "\nusage: $0 -type [folder|file|split-fastq] -source SOURCE -aws_region AWS_REGION -dest DESTINATION [-grid-nodes INT -current-node INT]

";
}


if ($type eq "folder") {
    $bibis3call = ("java -jar $bibis3bin -r ".
		   "--region $aws_region ".
		   "-d $source $dest");
}
elsif ($type eq "file") {
    $bibis3call = ("java -jar $bibis3bin ".
		   "--region $aws_region ".
		   "-d $source $dest");
}
elsif ($type eq "split-fastq") {
    if (($grid_nodes eq '') || ($current_node eq '')) {
	die "specify grid-nodes and current-node for split-fastq download type\n";
    }
    $bibis3call = ("java -jar $bibis3bin ".
		   "--region $aws_region ".
		   "--grid-download ".
		   "--grid-download-feature-fastq ".
		   "--grid-nodes $grid_nodes ".
		   "--grid-current-node $current_node ".
		   "-d $source $dest");
}
else {
    die "specify corret download type!\n";
}

print STDERR "calling: $bibis3call\n";
system($bibis3call);
