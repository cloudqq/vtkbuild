FROM golang:1.13.10-alpine3.11

RUN apk update && apk add curl git make musl-dev gcc x264-dev build-base

ARG GLIBC_VER="2.28-r0"
RUN ALPINE_GLIBC_REPO="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
  curl -Ls https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub && \
  curl -Ls ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-${GLIBC_VER}.apk > /tmp/${GLIBC_VER}.apk && \
  apk add /tmp/${GLIBC_VER}.apk && \
  curl -Ls ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-bin-${GLIBC_VER}.apk > /tmp/${GLIBC_VER}-bin.apk && \
  apk add /tmp/${GLIBC_VER}-bin.apk && \
  rm -rf /tmp/*.apk /var/cache/apk/*

# Fix glibc ldd command - see https://github.com/sgerrand/alpine-pkg-glibc/issues/103.
RUN sed -i s/lib64/lib/ /usr/glibc-compat/bin/ldd
#RUN ldconfig && ldconfig -p

RUN env
RUN git clone https://github.com/gen2brain/x264-go.git /go/src/github.com/gen2brain/x264-go
RUN cd  /go/src/github.com/gen2brain/x264-go \
 && CGO_ENABLED=1 \
 go build -a -ldflags '-lx264 -lm'
# go help build
#cgo build -tags extlib



RUN git clone https://github.com/rviscarra/webrtc-remote-screen.git
RUN cd webrtc-remote-screen && make
