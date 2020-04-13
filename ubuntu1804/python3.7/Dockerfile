FROM ubuntu:18.04


ENV DEBIAN_FRONTEND noninteractive

ENV PYTHON_VER 3.8.2
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

# download and extract python
RUN wget https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tar.xz \
    && tar xf Python-${PYTHON_VER}.tar.xz \
    && cd Python-${PYTHON_VER} \
    && ./configure --enable-optimizations \
    && make -j `nproc`  \
    && make altinstall \
    && update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.8 1 \
    && update-alternatives --config python3
RUN python3 --version

