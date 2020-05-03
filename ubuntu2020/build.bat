
docker build --build-arg http_proxy=http://192.168.2.100:1088 --build-arg https_proxy=http://192.168.2.100:1088 . -t glbase 
docker build --build-arg http_proxy=http://192.168.2.100:1088 --build-arg https_proxy=http://192.168.2.100:1088   . -t glenv -f Dockerfile.vnc
docker build --build-arg http_proxy=http://192.168.2.100:1088 --build-arg https_proxy=http://192.168.2.100:1088  . -t devenv -f Dockerfile.vnc2
