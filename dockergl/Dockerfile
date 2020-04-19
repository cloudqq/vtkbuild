# VTK and OpenJDK n Alpine Linux
FROM utensils/opengl:stable

# Install some Alpine packages
RUN apk add --no-cache \
    bash \
    build-base \
    cmake \
    wget \
    python2-dev

    #mesa-dev \
    #mesa-osmesa \


# Download and extract VTK source, then configure and build VTK
RUN wget -nv -O- http://www.vtk.org/files/release/7.1/VTK-7.1.1.tar.gz | \
    tar xz && \
    cd VTK-7.1.1 && \
    cmake \
    -D CMAKE_BUILD_TYPE:STRING=Release \
    -D CMAKE_INSTALL_PREFIX:STRING=/usr \
    -D BUILD_DOCUMENTATION:BOOL=OFF \
    -D BUILD_EXAMPLES:BOOL=OFF \
    -D BUILD_TESTING:BOOL=OFF \
    -D BUILD_SHARED_LIBS:BOOL=ON \
    -D VTK_USE_X:BOOL=OFF \
    -D VTK_OPENGL_HAS_OSMESA:BOOL=ON \
    -D OSMESA_LIBRARY=/usr/local/lib/libOSMesa.so.8 \
    -D OSMESA_INCLUDE_DIR=/usr/local/include/GL/ \
    -D VTK_RENDERING_BACKEND:STRING=OpenGL \
    -D VTK_Group_MPI:BOOL=OFF \
    -D VTK_Group_StandAlone:BOOL=OFF \
    -D VTK_Group_Rendering:BOOL=ON \
    -D VTK_WRAP_PYTHON=ON \
    -D VTK_PYTHON_VERSION:STRING=2 \
    . && \
    make -j `nproc` && \
    make install && \
    cd .. && rm -rf VTK-7.1.1

