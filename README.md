docker-kraken-hmp
=================

Edit the bibigrid.properties file provided in the repository and add your ceredentials and
path to your SSH key file.

Start bibigrid:

    bibigrid.sh -u USER -c -o bibigrid.properties

Login to master node (see BiBiGrid output how to set environment variables):

    ssh -i ~/.ssh/SSH_CREDENTIALS.pem ubuntu@ec2-??????.compute.amazonaws.com

Clone the Docker Kraken Pipeline from Github:

    git clone https://github.com/asczyrba/docker-kraken-hmp.git

Build the Docker image (optional, image is hosted by Docker Hub already):

    sudo docker build -t "asczyrba/kraken-hmp" .
    sudo docker push asczyrba/kraken-hmp

The following commands assume that you have a cluster of 2 slave nodes with 32 cores each.

Download the Kraken DB:

     /vol/spool/docker-kraken-hmp/scripts/submit_kraken_download.sh 32 2 /vol/scratch /vol/spool s3://bibicloud-demo/kraken-db/minikraken_20140330.tar /vol/scratch/krakendb

Start the pipeline:

     /vol/spool/docker-kraken-hmp/scripts/submit_kraken_pipeline.sh 32 /vol/scratch/krakendb SRS015996 s3://human-microbiome-project/HHS/HMASM/WGS/anterior_nares/SRS015996.tar.bz2 /vol/spool /vol/scratch

Create report:

    /vol/spool/docker-kraken-hmp/scripts/submit_kraken_report.sh 4 /vol/scratch/krakendb SRS015996 s3://human-microbiome-project/HHS/HMASM/WGS/anterior_nares/SRS015996.tar.bz2 /vol/spool /vol/scratch
    
After logout, terminate the BiBiGrid cluster:

    bibigrid.sh -l
    bibigrid.sh -t CLUSTERID
    

