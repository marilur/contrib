NAME := fix-iptables
SRCS := \
	fix-iptables.sh

TAG ?= 1.0
REGISTRY ?= gcr.io/bowei-gke-dev
IMAGE := $(REGISTRY)/$(NAME):$(TAG)

all: push

push: image
	gcloud docker push $(IMAGE)

image: Dockerfile $(SRCS)
	docker build -f Dockerfile -t $(IMAGE) .

.PHONY: image push
