REGISTRY_NAME=webcliff
IMAGE_NAME=sonos-web
IMAGE_VERSION=latest
IMAGE_TAG=$(REGISTRY_NAME)/$(IMAGE_NAME):$(IMAGE_VERSION)


.PHONY: docker-build docker-push

docker-build:
	podman build -f Dockerfile -t $(IMAGE_TAG) .

docker-push:
	podman push $(IMAGE_TAG)
