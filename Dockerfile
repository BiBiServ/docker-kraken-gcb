####
# Docker kraken pipeline
#
####

# use the ubuntu:precise base image provided by dotCloud
FROM bibiserv/gcb-ubuntu

# the following required packages from the base ubuntu installation
# have already been installed in the bibiserv/ubuntu-gcb image
# to avoid high download traffic during the tutorial

#RUN apt-get update && \
#    apt-get install -y -f perl-modules libgomp1 python-swiftclient && \
#    rm -rf /var/lib/apt/lists/*

# create directories where the host file system can be mounted
RUN mkdir /vol

# copy the required scripts that run the pipeline from your machine to the
# Docker image and make them executable
ADD ./kraken/ /vol/kraken/
RUN chmod 755 /vol/kraken/*
ADD ./container_scripts/ /vol/scripts/

