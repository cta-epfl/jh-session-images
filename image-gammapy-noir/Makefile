tag:=$(shell find -type f -not -name \*sif  -exec cat '{}' \; | md5sum | cut -c1-8)

image:=odahub/jh-lst:$(tag)
sif_name:=jh-lst-$(tag).sif

build:
	docker build -t $(image) .

push:
	docker push $(image)

run:
	docker run -p 8888:8888 -p 8787:8787 $(image)


singularity:
	singularity build $(sif_name) docker-daemon://odahub/jh-lst:$(tag)


upload: #singularity
	gfal-copy $(sif_name) https://dcache.cta.cscs.ch:2880/lst/software/$(sif_name)
