#!/bin/bash

export AVALON_UID=`id -u` AVALON_GID=`id -g`
docker-compose -f ./docker-compose.yml pull
docker-compose -f ./docker-compose.yml build avalon
docker-compose -f ./docker-compose.yml up
