FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

ENV CMAKE_VER 3.17.1

RUN apt-get update && apt-get  -y install \
	curl \
	wget \
	git \
        libssl-dev \
	build-essential

WORKDIR /temp
RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VER}/cmake-${CMAKE_VER}.tar.gz
RUN tar xvf cmake-${CMAKE_VER}.tar.gz
RUN cd cmake-${CMAKE_VER} && ./bootstrap && make -j`nproc` && make install
RUN rm -rf /temp
RUN cmake --version

#RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz 
#RUN tar -tvf clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz 

