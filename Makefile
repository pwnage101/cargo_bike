# Copyright © 2017 Troy Sankey <sankeytms at gmail dot com>
# 
# This documentation describes Open Hardware and is licensed under the CERN OHL
# v1.2.  You may redistribute and modify this documentation under the terms of
# the CERN OHL v1.2 (http://ohwr.org/cernohl). This documentation is
# distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING OF
# MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A PARTICULAR PURPOSE.
# Please see the CERN OHL v1.2 for applicable conditions.

DEFAULT_IMAGE := freecad-ubuntu
ifdef IMAGE
    ifeq (,$(IMAGE))
        IMAGE := $(DEFAULT_IMAGE)
    endif
else
    IMAGE := $(DEFAULT_IMAGE)
endif

DEFAULT_PROJECT := cargo_bike.fcstd
ifdef PROJECT
    ifeq (,$(PROJECT))
        PROJECT := $(DEFAULT_PROJECT)
    endif
else
    PROJECT := $(DEFAULT_PROJECT)
endif

PROJECT_DIR := /home/user/project

.PHONY : run
run :
	xhost +local:root
	docker run -ti --rm -e DISPLAY=unix$(DISPLAY) --memory=1500m --memory-swap=-1 \
	    -v /tmp/.X11-unix:/tmp/.X11-unix \
	    -v $(shell pwd):/home/user/project \
	    $(IMAGE) freecad-daily $(PROJECT_DIR)/$(PROJECT)
	xhost -local:root

.PHONY : build-image
build-image :
	groups | grep docker
	docker build --build-arg CACHE_DATE=$(date) -t freecad-ubuntu .

.PHONY : clean
clean :
	rm output/*.pdf
