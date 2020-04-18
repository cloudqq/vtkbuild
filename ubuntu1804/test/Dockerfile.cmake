FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

ENV CMAKE_VER 3.17.1
ENV PYTHON3_VER 3.8.2
ENV PYTHON2_VER 2.7.17
ENV PREFIX=/opt
ENV VTK_MAJOR_VER=7.1
ENV VTK_VER=7.1.1

ENV PATH=${PATH}:${PREFIX}/bin

ENV common_build_packages="curl wget git libssl-dev  re2c  libffi-dev  build-essential  zlib1g-dev  libncurses5-dev  libncursesw5-dev" 
ENV mesa_build_packages="libexpat1-dev libelf-dev bison flex libgl1-mesa-dev libwayland-dev wayland-protocols libwayland-egl-backend-dev libxrandr-dev libxrandr2"
ENV drm_build_packages="libpciaccess-dev pkg-config"
ENV vtk_build_packages="libxt-dev"

WORKDIR /temp

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PREFIX}/lib


RUN apt-get update && apt-get  -y install ${common_build_packages} \
    ${mesa_build_packages} \
    ${drm_build_packages} \ 
    ${vtk_build_packages} \

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
    && ninja && ninja install 			 \
    && rm -rf /temp

# install libdrm
RUN cd /temp && wget -q https://dri.freedesktop.org/libdrm/libdrm-2.4.101.tar.xz \
    && tar xvf libdrm-2.4.101.tar.xz \
    && cd libdrm-2.4.101 && mkdir build && cd build && meson .. -Dudev=true && ninja install

RUN cd /temp \
    && pip3 install mako \
    && apt-get -y install libexpat1-dev libelf-dev bison flex libgl1-mesa-dev libwayland-dev wayland-protocols libwayland-egl-backend-dev \
    libxrandr-dev libxrandr2  \
    && wget -q https://mesa.freedesktop.org/archive/mesa-20.0.4.tar.xz \
    && tar xvf mesa-20.0.4.tar.xz  && mkdir build \
    && cd    build  \
    && CXXFLAGS="-O2 -g -DDEFAULT_SOFTWARE_DEPTH_BITS=31"   CFLAGS="-O2 -g -DDEFAULT_SOFTWARE_DEPTH_BITS=31" \
     meson \
     -Dbuildtype=release            \
     -Dgallium-drivers="swrast"     \
     -Dgallium-nine=false           \
     -Dglx=dri                      \
     -Dosmesa=gallium               \
     -Dvalgrind=false               \
     -Dlibunwind=false              \
     ../mesa-20.0.4                 \
     && unset GALLIUM_DRV DRI_DRIVERS \
     && ninja install


RUN cd /temp && wget -q https://www.tcpdump.org/release/libpcap-1.9.1.tar.gz \
&& tar xvf libpcap-1.9.1.tar.gz && cd libpcap-1.9.1 && ./configure --prefix=${PREFIX} && make -j`nproc` && make install

# include boost
RUN cd /temp && wget https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.bz2 \
    && tar xjf boost_1_72_0.tar.bz2 && cd boost_1_72_0 \
    && ./bootstrap.sh --prefix=${PREFIX} \
    && ./b2 cxxflags="--std=c++17" -j`nproc` install


# install vtk
RUN cd /temp && wget https://www.vtk.org/files/release/${VTK_MAJOR_VER}/VTK-${VTK_VER}.tar.gz \
    && tar xvf VTK-${VTK_VER}.tar.gz \
    && mkdir build-vtk-${VTK_VER}-off && cd build-vtk-${VTK_VER}-off \
    && cmake -D CMAKE_BUILD_TYPE=Release \
    -D PYTHON_INCLUDE_DIR=${PREFIX}/include/python2.7 \
    -D PYTHON_LIBRARY=${PREFIX}/lib/libpython2.7.so \
    -D PYTHON_EXECUTABLE:FILEPATH=`which python` \
    -D VTK_WRAP_PYTHON=ON	 \
    -D VTK_OPENGL_HAS_OSMESA=ON \
    -D VTK_DEFAULT_RENDER_WINDOW_OFFSCREEN=ON \
    -D VTK_USE_X=OFF \
    -D CMAKE_INSTALL_PREFIX=${PREFIX}/vtk${VTK_VER}offscreen \
    -D LIBRARY_OUTPUT_PATH=./output_libs \
    -D BOOST_ROOT=${PREFIX} \
    ../VTK-${VTK_VER} \
    && make -j`nproc` && make install \
    && cd /temp && mkdir build-vtk-${VTK_VER}-on && cd build-vtk-${VTK_VER}-on \
    && cmake -D CMAKE_BUILD_TYPE=Release \
    -D PYTHON_INCLUDE_DIR=${PREFIX}/include/python2.7 \
    -D PYTHON_LIBRARY=${PREFIX}/lib/libpython2.7.so \
    -D PYTHON_EXECUTABLE:FILEPATH=`which python` \
    -D VTK_WRAP_PYTHON=ON	 \
    -D VTK_OPENGL_HAS_OSMESA=ON \
    -D VTK_DEFAULT_RENDER_WINDOW_OFFSCREEN=OFF \
    -D OpenGL_GL_PREFERENCE=GLVND \
    -D VTK_USE_X=ON \
    -D CMAKE_INSTALL_PREFIX=${PREFIX}/vtk${VTK_VER}onscreen \
    -D LIBRARY_OUTPUT_PATH=./output_libs \
    -D BOOST_ROOT=${PREFIX} \
    ../VTK-${VTK_VER} \
    && make -j`nproc` && make install  
    #&& rm -rf /workspace/build-vtk-${VTK_VER}-on && rm -rf /workspace/build-vtk-${VTK_VER}-off

    #RUN cd /temp && wget https://www.vtk.org/files/release/8.2/VTK-8.2.0.tar.gz \
    #    && tar xvf VTK-8.2.0.tar.gz \
    #    && mkdir build-vtk-8.2.0-off && cd build-vtk-8.2.0-off \
    #    && cmake -D CMAKE_BUILD_TYPE=Release \
    #    -D PYTHON_INCLUDE_DIR=${PREFIX}/include/python2.7 \
    #    -D PYTHON_LIBRARY=${PREFIX}/lib/libpython2.7.so \
    #    -D PYTHON_EXECUTABLE:FILEPATH=`which python` \
    #    -D VTK_WRAP_PYTHON=ON	 \
    #    -D VTK_OPENGL_HAS_OSMESA=ON \
    #    -D VTK_DEFAULT_RENDER_WINDOW_OFFSCREEN=ON \
    #    -D VTK_USE_X=OFF \
    #    -D CMAKE_INSTALL_PREFIX=${PREFIX}/vtk820offscreen \
    #    -D LIBRARY_OUTPUT_PATH=./output_libs \
    #    -D BOOST_ROOT=${PREFIX} \
    #    ../VTK-8.2.0 \
    #    && make -j`nproc` && make install \
    #    && cd /workspace && mkdir build-vtk-8.2.0-on && cd build-vtk-8.2.0-on \
    #    && cmake -D CMAKE_BUILD_TYPE=Release \
    #    -D PYTHON_INCLUDE_DIR=${PREFIX}/include/python2.7 \
    #    -D PYTHON_LIBRARY=${PREFIX}/lib/libpython2.7.so \
    #    -D PYTHON_EXECUTABLE:FILEPATH=`which python` \
    #    -D VTK_WRAP_PYTHON=ON	 \
    #    -D VTK_OPENGL_HAS_OSMESA=ON \
    #    -D VTK_DEFAULT_RENDER_WINDOW_OFFSCREEN=OFF \
    #    -D VTK_USE_X=ON \
    #    -D CMAKE_INSTALL_PREFIX=${PREFIX}/vtk820onscreen \
    #    -D LIBRARY_OUTPUT_PATH=./output_libs \
    #    -D BOOST_ROOT=${PREFIX} \
    #    ../VTK-8.2.0 \
    #    && make -j`nproc` && make install  
    #    #&& rm -rf /workspace/build-vtk-8.2.0-on && rm -rf /workspace/build-vtk-8.2.0-off
    #

COPY asEnvUser /usr/local/sbin/
RUN chown root /usr/local/sbin/asEnvUser && chmod 700 /usr/local/sbin/asEnvUser

RUN git clone https://github.com/ncopa/su-exec.git su-exec \
  && cd su-exec \
  && make \
  && chmod 770 su-exec && cp su-exec /usr/local/sbin



