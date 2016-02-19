#! /usr/bin/python3


"""Scans direcotory for all kraken reports and sums all taxonomic levels up from input files for future import into Krona."""

import subprocess, sys

__author__ = "Madis Rumming"
__copyright__ = "Copyright 2014, FG Computational Metagenomics, Bielefeld University, Germany"
__version__ = "1.0"
__maintainer__ = "Madis Rumming"
__email__ = "mrumming@cebitec.uni-bielefeld.de"
__status__ = "Production"



if len(sys.argv) == 1 :
	print("\nUSAGE\n./kraken_to_txt 1 2 3\n\n1: Directory for ls (scan for kraken reports)\n2: Output filename\n3: Same output in all kraken files? y or n\n")
	exit()

files, error = output, error = subprocess.Popen(["ls -d -1 "+sys.argv[1]+'/*.report'], shell=1,stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()

files = files.decode('utf-8')

files = str(files).strip().split('\n')

lineage_dict = {}

for file_ in files:
	cur_file = open(file_)
	cur_level = []
	for line in cur_file:
		line = line.strip().split('\t')
		act_level = line[5].count('  ')
		cur_level = cur_level[0:act_level]
		cur_level.append(line[5].strip())

		cur_level_str = "\t".join(cur_level)
		if not cur_level_str in lineage_dict:
			lineage_dict[cur_level_str] = int(line[2])
		else:
			lineage_dict[cur_level_str] += int(line[2])
	cur_file.close()

outFile = open(sys.argv[2], 'w')

for entry in lineage_dict:
	if lineage_dict[entry] > 0:
		if sys.argv[3] == 'y':
			outFile.write(str(lineage_dict[entry]/len(files))+'\t'+entry+'\n')
		else:
			outFile.write(str(lineage_dict[entry])+'\t'+entry+'\n')


outFile.close()
