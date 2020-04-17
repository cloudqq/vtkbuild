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

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PREFIX}/lib

RUN wget https://www.python.org/ftp/python/${PYTHON2_VER}/Python-${PYTHON2_VER}.tar.xz \
    && tar xf Python-${PYTHON2_VER}.tar.xz \
    && cd Python-${PYTHON2_VER} \
    && ./configure --prefix=${PREFIX} --enable-shared \
    && make -j `nproc`  \
    && make altinstall \
    && update-alternatives --install /usr/bin/python python ${PREFIX}/bin/python2.7 1 \
    && update-alternatives --config python \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python get-pip.py \
    && python -mpip install -U pip \
    && update-alternatives --install /usr/bin/pip pip ${PREFIX}/bin/pip 1 \
    && update-alternatives --config pip \
    && pip --version

    #RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && ${PREFIX}/bin/python2.7 get-pip.py && ${PREFIX}/bin/pip install -U pip

# download and extract python
RUN wget https://www.python.org/ftp/python/${PYTHON3_VER}/Python-${PYTHON3_VER}.tar.xz \
    && tar xf Python-${PYTHON3_VER}.tar.xz \
    && cd Python-${PYTHON3_VER} \
    && ./configure --prefix=${PREFIX} --enable-shared \
    && make -j `nproc`  \
    && make altinstall \
    && update-alternatives --install /usr/bin/python3 python3 ${PREFIX}/bin/python3.8 1 \
    && update-alternatives --config python3 \
    && update-alternatives --install /usr/bin/pip3 pip3 ${PREFIX}/bin/pip3.8 1 \
    && update-alternatives --config pip3 \
    && python3 --version \
    && pip3 install -U pip && pip3 --version

RUN git clone git://github.com/ninja-build/ninja.git && cd ninja && git checkout release && python configure.py --bootstrap \
    && ./ninja --version  && cp ninja ${PREFIX}/bin 

RUN git clone https://github.com/mesonbuild/meson.git \
    && cd meson && python3 setup.py build && python3 setup.py install --prefix=${PREFIX} \
    && update-alternatives --install /usr/bin/meson meson ${PREFIX}/bin/meson 1 \
    && update-alternatives --config meson \
    && meson --version

    
