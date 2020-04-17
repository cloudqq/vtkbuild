FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

ENV CMAKE_VER 3.17.1
ENV PYTHON3_VER 3.8.2
ENV PYTHON2_VER 2.7.17
ENV PREFIX=/opt

RUN apt-get update && apt-get  -y install \
	curl \
	wget \
	git \
        libssl-dev \
        re2c \
        libffi-dev \
	build-essential \
	zlib1g-dev \
	libncurses5-dev \
       	libncursesw5-dev 

WORKDIR /temp

RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VER}/cmake-${CMAKE_VER}.tar.gz \
&& tar xvf cmake-${CMAKE_VER}.tar.gz && cd cmake-${CMAKE_VER} && ./bootstrap --prefix=${PREFIX} && make -j`nproc` && make install 

# install python2.7.17
RUN wget https://www.python.org/ftp/python/${PYTHON2_VER}/Python-${PYTHON2_VER}.tar.xz \
    && tar xf Python-${PYTHON2_VER}.tar.xz \
    && cd Python-${PYTHON2_VER} \
    && ./configure --prefix=${PREFIX} --enable-shared \
    && make -j `nproc`  \
    && make altinstall \
    && update-alternatives --install ${PREFIX}/bin/python python /opt/bin/python2.7 1 \
    && update-alternatives --config python

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PREFIX}/lib
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && /opt/bin/python2.7 get-pip.py && ${PREFIX}/bin/pip install -U pip
