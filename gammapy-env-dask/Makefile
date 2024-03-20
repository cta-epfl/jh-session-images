tag:=$(shell find -type f -exec cat '{}' \; | md5sum | cut -c1-8)
GAMMAPY_VERSION?=1.2
lstchain_version?=0.9.6

image:=odahub/jh-cta:$(tag)-gammapy-$(GAMMAPY_VERSION)-lstchain-$(lstchain_version)

build:
	docker build --build-arg GAMMAPY_VERSION=${GAMMAPY_VERSION} --build-arg LSTCHAIN_VERSION=$(lstchain_version) -t $(image) .

push:
	docker push $(image)

run:
	docker run -p 8888:8888 -p 8787:8787 $(image)
