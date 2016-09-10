docker-kraken-gcb
=================

First, we need to start a bibigrid cluster in the cloud. If you have
not done this already, edit the properties file downloaded from the
gcb-tutorial repository and add your credentials and path to your SSH
key file. 

Start bibigrid:

    bibigrid -u $USER -c -o bibigrid.properties

Login to master node (see BiBiGrid output how to set environment variables):

    ssh -i ~/.ssh/SSH_CREDENTIALS.pem ssh -i id_rsa ubuntu@$BIBIGRID_MASTER

Now your are logged on to the master node of your cloud-based SGE
cluster! We will clone the docker-kraken-gcb github repository to
the master node and continue working on the master node.

Clone the Docker Kraken Pipeline from Github:

    cd /vol/spool
    git clone https://github.com/bibiserv/docker-kraken-gcb.git
    cd docker-kraken-gcb

The command line calls on this page assume that you have several
environment variables set for your cloud environment. This makes it
easier to copy & paste the commands:

    export DOCKER_USERNAME=<DOCKERHUB ACCOUNT NAME>
    export NUM_NODES=4
    export NUM_CORES=4
    export HOST_SPOOLDIR=/vol/spool
    export HOST_SCRATCHDIR=/vol/scratch

Build the Docker image:

    docker build -t "$DOCKER_USERNAME/kraken-docker" .
    docker login -u $DOCKER_USERNAME
    docker push $DOCKER_USERNAME/kraken-docker

Submit a script to each host to download the Kraken DB:

     /vol/spool/docker-kraken-gcb/scripts/submit_kraken_download.sh $NUM_NODES $NUM_CORES $HOST_SCRATCHDIR $HOST_SPOOLDIR /dev/shm s3://bibicloud-demo-oregon/kraken-db/krakendb_120GB.tar us-west-2 /vol/mem/krakendb
     
Start the pipeline:

     /vol/spool/docker-kraken-hmp/scripts/submit_kraken_pipeline.sh $NUM_CORES /vol/mem/krakendb SRS015996 s3://human-microbiome-project/HHS/HMASM/WGS/anterior_nares/SRS015996.tar.bz2 /vol/spool /vol/scratch /dev/shm

After logout, terminate the BiBiGrid cluster:

    bibigrid.sh -l
    bibigrid.sh -t CLUSTERID
    

