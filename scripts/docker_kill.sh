#!/bin/sh

docker ps  | cut -f1 | grep -v CON | xargs sudo docker kill
