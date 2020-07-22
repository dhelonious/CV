BUILD = build

all: CV.tex
	latexmk CV.tex
	@cp $(BUILD)/CV.pdf .

clean:
	rm -fr $(BUILD)

.PHONY: all clean
