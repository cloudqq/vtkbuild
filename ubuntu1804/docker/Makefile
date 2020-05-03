

BUILD_DATE := 20200503
#HTTP_PROXY := http://192.168.2.100:1088
#HTTPS_PROXY := http://192.168.2.100:1088
HTTP_PROXY := ""
HTTPS_PROXY := ""
OWNER := cloudqq
NAME  := pointcloud-dev-env
TAG   := $(OWNER)/$(NAME):$(BUILD_DATE)


.PHONY: default
default:
	docker build \
	    --build-arg HTTP_PROXY=$(HTTP_PROXY) \
	    --build-arg HTTPS_PROXY=$(HTTPS_PROXY) \
		-f Dockerfile .








.PHONY: default
default:
	docker build \
	    --build-arg HTTP_PROXY=$(HTTP_PROXY) \
	    --build-arg HTTPS_PROXY=$(HTTPS_PROXY) \
	    -f Dockerfile . -t $(TAG) 



.PHONY: release
release:
	docker push $(TAG)



