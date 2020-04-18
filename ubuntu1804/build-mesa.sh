#!/bin/sh

docker build --squash . -f Dockerfile.mesa -t mesaenv
