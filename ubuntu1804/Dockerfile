FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

ENV CMAKE_VER 3.17.1

RUN apt-get update && apt-get  -y install \
	curl \
	wget \
	git \
        libssl-dev \
        python2.7 \
        re2c \
        libffi-dev \
	ninja-build \
	build-essential

WORKDIR /temp
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VER}/cmake-${CMAKE_VER}.tar.gz \
    && tar xvf cmake-${CMAKE_VER}.tar.gz && cd cmake-${CMAKE_VER} && ./bootstrap && make -j`nproc` && make install \
    && cmake --version \
    && rm -rf /temp

RUN git clone git://github.com/ninja-build/ninja.git && cd ninja && git checkout release && python2.7 configure.py && ninja && cp ninja /usr/bin && rm -rf /temp

RUN    wget -q https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/llvm-10.0.0.src.tar.xz \
    && wget -q https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang-10.0.0.src.tar.xz \
    && wget -q https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/compiler-rt-10.0.0.src.tar.xz \
    && tar xf llvm-10.0.0.src.tar.xz \
    && cd llvm-10.0.0.src \
    && tar xvf ../compiler-rt-10.0.0.src.tar.xz -C projects \
    && tar xvf ../clang-10.0.0.src.tar.xz -C tools \
    && mv tools/clang-10.0.0.src tools/clang \
    && mv projects/compiler-rt-10.0.0.src projects/compiler-rt \
    && mkdir -v build && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr         \
       -DLLVM_ENABLE_FFI=ON                      \
       -DCMAKE_BUILD_TYPE=Release                \
       -DLLVM_BUILD_LLVM_DYLIB=ON                \
       -DLLVM_LINK_LLVM_DYLIB=ON                 \
       -DLLVM_ENABLE_RTTI=ON                     \
       -DLLVM_TARGETS_TO_BUILD="host;AMDGPU;BPF" \
       -DLLVM_BUILD_TESTS=ON                     \
       -Wno-dev -G Ninja .. \
    && ninja && ninja install \
    && rm -rf /temp
                     
ENV PYTHON_VER 3.8.2
RUN apt-get update && apt-get  -y install \
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
        tk-dev 

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



#RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz 
#RUN tar -tvf clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz 

