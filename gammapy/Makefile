tag:=$(shell find -type f -exec cat '{}' \; | md5sum | cut -c1-8)
gammapy_revision?=1.2

image:=odahub/jh-cta:$(tag)-gammapy-$(gammapy_revision)

build:
	docker build --build-arg GAMMAPY_REVISION=${gammapy_revision} -t $(image) .

push:
	docker push $(image)

run:
	docker run -p 8888:8888 -p 8787:8787 $(image)
