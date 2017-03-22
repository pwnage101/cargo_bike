# Copyright © 2017 Troy Sankey <sankeytms at gmail dot com>
# 
# This documentation describes Open Hardware and is licensed under the CERN OHL
# v1.2.  You may redistribute and modify this documentation under the terms of
# the CERN OHL v1.2 (http://ohwr.org/cernohl). This documentation is
# distributed WITHOUT ANY EXPRESS OR IMPLIED WARRANTY, INCLUDING OF
# MERCHANTABILITY, SATISFACTORY QUALITY AND FITNESS FOR A PARTICULAR PURPOSE.
# Please see the CERN OHL v1.2 for applicable conditions.

DRAWINGS := full_side_full full_side_steerer full_side_fork
DRAWINGS := $(addprefix output/,$(DRAWINGS))

$(DRAWINGS:=.pdf) : cargo_bike.fcstd.intermediate

.INTERMEDIATE : cargo_bike.fcstd.intermediate
cargo_bike.fcstd.intermediate : cargo_bike.fcstd
	scripts/make_drawings.sh --headless

%_cropped.pdf : %.pdf
	inkscape --export-area-drawing --without-gui --export-pdf=$@ $<

.PHONY : drawings
drawings : $(DRAWINGS:=_cropped.pdf)

.PHONY : open
open :
	xhost +local:root
	docker run -ti --rm -e DISPLAY=unix$(DISPLAY) --net=none \
	    -v /tmp/.X11-unix:/tmp/.X11-unix \
	    -v $(shell pwd):/home/user/project \
	    freecad-ubuntu freecad-daily /home/user/project/cargo_bike.fcstd
	xhost -local:root

.PHONY : build-image
build-image :
	groups | grep docker
	docker build -t freecad-ubuntu .

.PHONY : clean
clean :
	rm output/*.pdf
