####
# Docker kraken pipeline
#
####

# use the ubuntu:precise base image provided by dotCloud
FROM ubuntu:14.04

MAINTAINER Name asczyrba@cebitec.uni-bielefeld.de

# install the required packages to the base ubuntu installation
# e.g. RUN apt-get install -y -f bc

RUN apt-get update
RUN apt-get install -y -f perl-modules libgomp1 openjdk-7-jre lbzip2

# create directories where the host file system can be mounted
RUN mkdir /vol

# copy the required scripts that run the pipeline from your machine to the
# Docker image and make them executable
ADD ./kraken/ /vol/kraken/
RUN chmod 755 /vol/kraken/*
ADD ./scripts/ /vol/scripts/

# set entrypoint to initialize the pipeline
#ENTRYPOINT ["/vol/scripts/init_pipeline.sh"]
