
docker build --build-arg http_proxy=http://172.31.0.29:1088 --build-arg https_proxy=https://172.31.0.29:1088  . -t cloudqq/vncgoenv:20200430 -f Dockerfile.go.vnc
