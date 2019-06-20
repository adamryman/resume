
BODY=body.md
HEADER=header.md
BUILD_DIR=build/

all: builddir pdf html

latex:
	pandoc --template templates/header.latex --variable geometry="margin=0.6in" -o $(BUILD_DIR)header.latex $(HEADER)
	# landscape
	#pandoc --template templates/body.latex --variable geometry="top=3in, bottom=1.5in, left=0.5in, right=0.5in" -V geometry="landscape" -o $(BUILD_DIR)body.latex $(BODY)
	# not landscape
	# NOTE: edit top for moving body text
	pandoc --template templates/body.latex --variable geometry="top=6.0in, bottom=1.5in, left=0.6in, right=0.6in"  -o $(BUILD_DIR)body.latex $(BODY)

pdf: latex
	pdflatex -jobname=$(BUILD_DIR)header $(BUILD_DIR)header.latex
	pdflatex -jobname=$(BUILD_DIR)body $(BUILD_DIR)body.latex
	pdftk $(BUILD_DIR)header.pdf background $(BUILD_DIR)body.pdf output $(BUILD_DIR)resume.pdf

html:
	pandoc -o $(BUILD_DIR)header.html $(HEADER)
	pandoc -o $(BUILD_DIR)body.html $(BODY)

builddir:
	@mkdir -p $(BUILD_DIR)
