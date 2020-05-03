

BUILD_DATE := 20200503
HTTP_PROXY := http://192.168.2.100:1088
HTTPS_PROXY := http://192.168.2.100:1088


.PHONY: default
default:
	docker build \
	    --build-arg HTTP_PROXY=$(HTTP_PROXY) \
	    --build-arg HTTPS_PROXY=$(HTTPS_PROXY) \
		-f Dockerfile .






