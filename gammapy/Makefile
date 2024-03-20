tag:=$(shell find -type f -exec cat '{}' \; | md5sum | cut -c1-8)
GAMMAPY_VERSION?=1.2

image:=odahub/jh-cta:$(tag)-gammapy-$(GAMMAPY_VERSION)

build:
	docker build --build-arg GAMMAPY_VERSION=${GAMMAPY_VERSION} -t $(image) .

push:
	docker push $(image)

run:
	docker run -p 8888:8888 -p 8787:8787 $(image)
