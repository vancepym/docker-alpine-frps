IMAGE = vancepym/alpine-frps

.PHONY: all build force push devel

all: build

build:
	docker build -t $(IMAGE) .

force:
	docker build --force-rm --no-cache -t $(IMAGE) .

push:
	docker push $(IMAGE)

devel: build
	docker run --rm -it $(IMAGE) $@

