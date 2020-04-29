FROM ubuntu:bionic as builder

RUN apt-get update && apt-get install -y libtool-bin autoconf python-pip libx11-dev libxext-dev x11proto-core-dev x11proto-gl-dev libglew-dev freeglut3-dev bison flex

# Build Mesa
RUN apt-get install -y wget pkg-config zlib1g-dev llvm-dev
RUN wget https://mesa.freedesktop.org/archive/mesa-18.2.4.tar.xz
RUN tar xf mesa-18.2.4.tar.xz
RUN mkdir mesa-18.2.4/build
WORKDIR mesa-18.2.4/build

RUN ../configure --disable-dri \
               --disable-egl \
               --disable-gbm \
               --with-gallium-drivers=swrast,swr \
               --with-platforms=x11 \
               --prefix=/usr/local/ \
               --enable-gallium-osmesa \
               --disable-xvmc --disable-vdpau --disable-va \
               --with-swr-archs=avx

RUN make -j `nproc` && make install

RUN apt-get install -y git \
  &&  git clone https://github.com/ncopa/su-exec.git /var/tmp/build/su-exec \
  && cd /var/tmp/build/su-exec \
  && make \
  && chmod 770 su-exec

# Copy our entrypoint into the container.
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

# Create fresh image from alpine
FROM ubuntu:bionic

RUN apt-get update && apt-get install -y \
        llvm \
	llvm-6.0 \
	xvfb

# Copy the Mesa build & entrypoint script from previous stage
COPY --from=builder /usr/local /usr/local

COPY --from=builder /var/tmp/build/su-exec /usr/local/sbin
COPY asEnvUser /usr/local/sbin/

RUN chown root /usr/local/sbin/asEnvUser \
  && chmod 700  /usr/local/sbin/asEnvUser

# Setup our environment variables.
ENV XVFB_WHD="1920x1080x24"\
    DISPLAY=":99" \
    LIBGL_ALWAYS_SOFTWARE="1" \
    GALLIUM_DRIVER="softpipe"


EXPOSE 5900

ADD run_supervisord.sh /sbin/
ENTRYPOINT ["sh", "/sbin/run_supervisord.sh"]

#CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
#ENTRYPOINT ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]

#CMD ["bash","/sbin/run_supervisord.sh"]
