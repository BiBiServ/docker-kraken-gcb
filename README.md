# docker-kraken-gcb

## Start BiBiGrid Cluster
First, we need to start a bibigrid cluster in the cloud. If you have
not done this already, edit the properties file downloaded from the
gcb-tutorial repository and add your credentials and path to your SSH
key file. 

Start bibigrid:

    bibigrid -u $USER -c -o bibigrid.properties

Login to master node (see BiBiGrid output how to set environment variables):

    ssh -i ~/.ssh/SSH_CREDENTIALS.pem ssh -i id_rsa ubuntu@$BIBIGRID_MASTER

## Download Github repository
Now your are logged on to the master node of your cloud-based SGE
cluster! We will clone the docker-kraken-gcb github repository to
the master node and continue working on the master node.

Clone the Docker Kraken Pipeline from Github:

    cd /vol/spool
    git clone https://github.com/bibiserv/docker-kraken-gcb.git
    cd docker-kraken-gcb

## Set environment variables
The command line calls on this page assume that you have several
environment variables set for your cloud environment. This makes it
easier to copy & paste the commands:

    export NUM_NODES=4
    export NUM_CORES=4
    export HOST_SPOOLDIR=/vol/spool
    export HOST_SCRATCHDIR=/vol/scratch
    export DOCKER_USERNAME=<DOCKERHUB ACCOUNT NAME>

## Kraken Docker Image

The Dockerfile includes all information about the Docker image.
Place scripts you want to have accessible in the image
into the container_scripts directory. These scripts will be
called to donwload the database to the hosts and run the analyses.

### Login to DockerHub

We need to pull the updated image to each of the hosts
before we can start the analysis scripts. Before pushing 
to the DockerHub, you need to login:

    docker login -u $DOCKER_USERNAME
    
### Building and Pushing the Docker Image 

Now every time you made a changes to the container scripts,
you need to push the image to DockerHub:

    docker build -t "$DOCKER_USERNAME/kraken-docker" .
    docker push $DOCKER_USERNAME/kraken-docker

## Running Kraken containers on the cluster nodes

### Download Kraken Database

First we need to download the Kraken database to each of
the hosts. We can use the SGE to distribute the jobs on the
cluster. The `-pe` option ensures, that we only download the 
database **once on each host**:

    qsub -N DB_Download -t 1-$NUM_NODES -pe multislot $NUM_CORES -cwd \
    /vol/spool/docker-kraken-gcb/scripts/docker_run.sh \
    $DOCKER_USERNAME/kraken-docker $HOST_SCRATCHDIR $HOST_SPOOLDIR \
    /vol/scripts/kraken_download_db.sh

### Run Kraken Analysis

Start the pipeline for just one input file:

    qsub -N kraken_SRR935726 -pe multislot $NUM_CORES -cwd \
    /vol/spool/docker-kraken-gcb/scripts/docker_run.sh \
    $DOCKER_USERNAME/kraken-docker $HOST_SCRATCHDIR $HOST_SPOOLDIR \
    "/vol/scripts/kraken_pipeline.sh SRR935726.fastq.gz SRR935726"

You will find the output files in `/vol/spool`.

If your pipeline is working, analyze all FASTQ files:

    for i in `cat samples.txt | sed 's/.fastq.gz//g'`
    do 
    qsub -N kraken_$i -pe multislot $NUM_CORES -cwd \
    /vol/spool/docker-kraken-gcb/scripts/docker_run.sh \
    $DOCKER_USERNAME/kraken-docker $HOST_SCRATCHDIR $HOST_SPOOLDIR \
    "/vol/scripts/kraken_pipeline.sh $i.fastq.gz $i"
    done
    
### Generate Krona plot

    cd /vol/spool
    for i in *out; do cut -f2,3 $i > $i.krona; done
    ktImportTaxonomy *krona -o krona.html
    cp -r krona.html* ~/public_html
    
You can use your browser to look at the Krona output.
Go to: `http://<BIBIGRID_MASTER>/~ubuntu/`

## Clean up

After logout, terminate the BiBiGrid cluster:

    bibigrid -o bibigrid.properties -l
    bibigrid -o bibigrid.properties -t CLUSTERID
    

