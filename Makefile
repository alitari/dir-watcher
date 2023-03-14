DOCKER_REGISTRY ?= localhost:5001
DOCKER_REPO = alitari
DOCKER_IMAGE_NAME = dir-watcher
DOCKER_IMAGE_TAG = latest

INOTIFYWAIT_ARGS ?= "-e create -e moved_from -e modify"

COMMAND ?= "echo"

build: dir-watcher.sh Dockerfile .dockerignore
	docker build -t $(DOCKER_REGISTRY)/$(DOCKER_REPO)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .

push: build
	docker push $(DOCKER_REGISTRY)/$(DOCKER_REPO)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

run: build
	docker run -it --rm -v $(PWD)/watch:/watch -e COMMAND="$(COMMAND)" -e INOTIFYWAIT_ARGS="$(INOTIFYWAIT_ARGS)" $(DOCKER_REGISTRY)/$(DOCKER_REPO)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) /watch

deploy: push
	kubectl apply -f k8s