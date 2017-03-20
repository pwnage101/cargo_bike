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

.PHONY : clean
clean :
	rm output/*.pdf
