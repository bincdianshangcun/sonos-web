CURRENT_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
TARGET_FOLDER = ${HOME}/.local/bin

LIST = run-sonos-web.sh

REGISTRY_NAME=webcliff
IMAGE_NAME=sonos-web
IMAGE_VERSION=latest
IMAGE_TAG=$(REGISTRY_NAME)/$(IMAGE_NAME):$(IMAGE_VERSION)


.PHONY: docker-build docker-push

docker-build:
	podman build -f Dockerfile -t $(IMAGE_TAG) .

docker-push:
	podman push $(IMAGE_TAG)


.PHONY: link 
link:
	for i in $(LIST); do \
		rm -rf $(TARGET_FOLDER)/$$i; \
		ln -s $(CURRENT_DIR)$$i $(TARGET_FOLDER)/$$i; \
	done
