FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get  -y install \
	curl \
	wget \
	git \
	build-essential

RUN wget https://github.com/Kitware/CMake/releases/download/v3.17.1/cmake-3.17.1.tar.gz
RUN tar xvf cmake-3.17.1.tar.gz
RUN cd cmake-3.17.1

#RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz 
#RUN tar -tvf clang+llvm-10.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz 

