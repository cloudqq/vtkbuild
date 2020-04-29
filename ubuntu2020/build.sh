#!/bin/sh
docker build . -t glbase 
docker build . -t glenv -f Dockerfile.vnc
docker build . -t devenv -f Dockerfile.vnc2
