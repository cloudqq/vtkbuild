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

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PREFIX}/lib

RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VER}/cmake-${CMAKE_VER}.tar.gz \
&& tar xvf cmake-${CMAKE_VER}.tar.gz && cd cmake-${CMAKE_VER} && ./bootstrap --prefix=${PREFIX} && make -j`nproc` && make install  \
    && update-alternatives --install /usr/bin/cmake cmake ${PREFIX}/bin/cmake 1 \
    && update-alternatives --config cmake \
    && cmake --version \
    \
    \ 
    && wget https://www.python.org/ftp/python/${PYTHON2_VER}/Python-${PYTHON2_VER}.tar.xz \
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
    && pip --version \
    \
    \
    && wget https://www.python.org/ftp/python/${PYTHON3_VER}/Python-${PYTHON3_VER}.tar.xz \
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
    && pip3 install -U pip && pip3 --version \
    \
    \
    && git clone git://github.com/ninja-build/ninja.git && cd ninja && git checkout release && python configure.py --bootstrap \
    && ./ninja --version  && cp ninja ${PREFIX}/bin  \
    && update-alternatives --install /usr/bin/ninja ninja ${PREFIX}/bin/ninja 1 \
    && update-alternatives --config ninja \
    && ninja --version \
    \
    && cd /temp \ 
    && git clone https://github.com/mesonbuild/meson.git \
    && cd meson && python3 setup.py build && python3 setup.py install --prefix=${PREFIX} \
    && update-alternatives --install /usr/bin/meson meson ${PREFIX}/bin/meson 1 \
    && update-alternatives --config meson \
    && meson --version \

    
    RUN cd /temp \
    && wget -q https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/llvm-10.0.0.src.tar.xz \
    && wget -q https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang-10.0.0.src.tar.xz \
    && wget -q https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/compiler-rt-10.0.0.src.tar.xz \
    && tar xf llvm-10.0.0.src.tar.xz \
    && cd llvm-10.0.0.src \
    && tar xvf ../compiler-rt-10.0.0.src.tar.xz -C projects \
    && tar xvf ../clang-10.0.0.src.tar.xz -C tools \
    && mv tools/clang-10.0.0.src tools/clang \
    && mv projects/compiler-rt-10.0.0.src projects/compiler-rt \
    && mkdir -v build && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX=${PREFIX}    \
       -DLLVM_ENABLE_FFI=ON                      \
       -DCMAKE_BUILD_TYPE=Release                \
       -DLLVM_BUILD_LLVM_DYLIB=ON                \
       -DLLVM_LINK_LLVM_DYLIB=ON                 \
       -DLLVM_ENABLE_RTTI=ON                     \
       -DLLVM_TARGETS_TO_BUILD="host;AMDGPU;BPF" \
       -DLLVM_BUILD_TESTS=ON                     \
       -Wno-dev -G Ninja ..                      \
    && rm -rf /temp

RUN apt-get -y install libpciaccess-dev pkg-config
# install libdrm
RUN cd /temp && wget -q https://dri.freedesktop.org/libdrm/libdrm-2.4.101.tar.xz \
    && tar xvf libdrm-2.4.101.tar.xz \
    && cd libdrm-2.4.101 && mkdir build && cd build && meson .. -Dudev=true && ninja install

COPY asEnvUser /usr/local/sbin/
RUN chown root /usr/local/sbin/asEnvUser && chmod 700 /usr/local/sbin/asEnvUser

RUN git clone https://github.com/ncopa/su-exec.git su-exec \
  && cd su-exec \
  && make \
  && chmod 770 su-exec && cp su-exec /usr/local/sbin



