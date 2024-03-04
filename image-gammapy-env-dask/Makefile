tag:=$(shell find -type f -exec cat '{}' \; | md5sum | cut -c1-8)
gammapy_revision?=1.2
lstchain_version?=0.9.6

image:=odahub/jh-cta:$(tag)-gammapy-$(gammapy_revision)-lstchain-$(lstchain_version)

build:
	docker build --build-arg GAMMAPY_REVISION=${gammapy_revision} --build-arg LSTCHAIN_VERSION=$(lstchain_version) -t $(image) .

push:
	docker push $(image)

run:
	docker run -p 8888:8888 -p 8787:8787 $(image)
