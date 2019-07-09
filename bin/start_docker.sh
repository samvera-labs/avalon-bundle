#!/bin/bash

export UID=`id -u` GID=`id -g`
docker-compose pull
docker-compose up avalon
