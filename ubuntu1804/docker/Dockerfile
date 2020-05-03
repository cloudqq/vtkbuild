# cmake ninja meson python3
FROM ubuntu:18.04 as builder

# build dev tools cmake meson ninja
ENV DEBIAN_FRONTEND noninteractive
ENV CMAKE_VER 3.17.1

ENV common_build_packages="curl wget git libssl-dev  re2c  libffi-dev  build-essential  zlib1g-dev  libncurses5-dev  libncursesw5-dev python3 python3-pip" 

ENV PREFIX=/usr/local
WORKDIR /temp

RUN apt-get update && apt-get  -y install ${common_build_packages}

RUN pip3 install -U pip setuptools \
    && wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VER}/cmake-${CMAKE_VER}.tar.gz \
&& tar xvf cmake-${CMAKE_VER}.tar.gz && cd cmake-${CMAKE_VER} && ./bootstrap --prefix=${PREFIX} && make -j`nproc` && make install  \
    && update-alternatives --install /usr/bin/cmake cmake ${PREFIX}/bin/cmake 1 \
    && update-alternatives --config cmake \
    && cmake --version \
    && cd /temp && git clone git://github.com/ninja-build/ninja.git && cd ninja && git checkout release && python3 configure.py --bootstrap \
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
    && cd / && rm -rf /temp

ENV CMAKE_VER 3.17.1

ENV PREFIX=/usr/local
WORKDIR /temp

RUN cd /temp \
&& wget  https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/llvm-10.0.0.src.tar.xz \
&& wget  https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang-10.0.0.src.tar.xz \
&& wget  https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/compiler-rt-10.0.0.src.tar.xz \
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
&& ninja -j `nproc` && ninja install                        \
&& rm -rf /temp

