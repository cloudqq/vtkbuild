#!/bin/sh

USER=cloudqq
WORKDIR=/mnt/workspace

docker run -it --rm \
	-v $(pwd):${WORKDIR} \
	 -e DOCKER_HOST=tcp://172.17.0.1:2375 \
	 -e http_proxy= \
	 -e https_proxy= \
	 -e privileged \
	 -e DISPLAY=$DISPLAY \
	 -e UNAME="${USER}"\
	 -e GNAME="${USER}"\
	 -e UID="1000"\
	 -e GID="1000"\
	 -e UHOME="/home/${USER}" \
	 -e WORKSPACE="${WORKDIR}" \
	 -e LANG=zh_CN.UTF-8 \
	 -e LANGUAGE=zh_CN:en_US \
	 -e LC_CTYPE=en_US.UTF-8 \
	 -v ${HOME}/.Xauthority:/home/${USER}/.Xauthority \
	 -w "${WORKDIR}" \
	 vtk82 
