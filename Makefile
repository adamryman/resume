
BODY=body.md
HEADER=header.md
BUILD_DIR=build/

all: builddir pdf html

latex:
	pandoc --template templates/header.latex --variable geometry="margin=0.5in" -o $(BUILD_DIR)header.latex $(HEADER)
	pandoc --template templates/body.latex --variable geometry="top=4.5in, bottom=0.5in, left=0.5in, right=0.5in" -o $(BUILD_DIR)body.latex $(BODY)

pdf: latex
	pdflatex -jobname=$(BUILD_DIR)header $(BUILD_DIR)header.latex
	pdflatex -jobname=$(BUILD_DIR)body $(BUILD_DIR)body.latex
	pdftk $(BUILD_DIR)header.pdf background $(BUILD_DIR)body.pdf output $(BUILD_DIR)resume.pdf

html:
	pandoc -o $(BUILD_DIR)header.html $(HEADER)
	pandoc -o $(BUILD_DIR)body.html $(BODY)

builddir:
	@mkdir -p $(BUILD_DIR)
