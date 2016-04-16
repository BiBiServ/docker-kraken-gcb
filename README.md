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

The following commands assume that you have a cluster of 99 slave nodes with 32 cores each.

Download the Kraken DB:

     /vol/spool/docker-kraken-hmp/scripts/submit_kraken_download.sh 32 99 /vol/scratch /vol/spool /dev/shm s3://bibicloud-demo-oregon/kraken-db/krakendb_120GB.tar us-west-2 /vol/mem/krakendb
     
Start the pipeline:

     /vol/spool/docker-kraken-hmp/scripts/submit_kraken_pipeline.sh 32 /vol/mem/krakendb SRS015996 s3://human-microbiome-project/HHS/HMASM/WGS/anterior_nares/SRS015996.tar.bz2 /vol/spool /vol/scratch /dev/shm

After logout, terminate the BiBiGrid cluster:

    bibigrid.sh -l
    bibigrid.sh -t CLUSTERID
    

