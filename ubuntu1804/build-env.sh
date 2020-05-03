#!/bin/sh
docker build --build-arg http_proxy=http://192.168.2.100:1088 --build-arg https_proxy=http://192.168.2.100:1088 . -f Dockerfile.buildenv -t buildenv
