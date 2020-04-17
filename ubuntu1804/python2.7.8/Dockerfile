FROM ubuntu:18.04


ENV DEBIAN_FRONTEND noninteractive

ENV PYTHON_VER 2.7.17
RUN apt-get update && apt-get  -y install \
        curl \
	zlib1g-dev \
	libncurses5-dev \
       	libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev  \
        libgdbm-dev \
        libdb5.3-dev \
 	libbz2-dev \
 	libexpat1-dev \
        liblzma-dev \
        tk-dev \
        wget \
        git \
        libssl-dev 


# install build tools and python prerequisites

WORKDIR /workspace
# download and extract python
RUN wget https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tar.xz \
    && tar xf Python-${PYTHON_VER}.tar.xz \
    && cd Python-${PYTHON_VER} \
    && ./configure --enable-optimizations --enable-shared \
    && make -j `nproc`  \
    && make altinstall \
    && update-alternatives --install /usr/bin/python python /usr/local/bin/python2.7 1 \
    && update-alternatives --config python

RUN ldconfig && ldconfig -p | grep python
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python get-pip.py && pip install -U pip

RUN python --version

