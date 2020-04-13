TOP_MARGIN=0.35
LEFT_MARGIN=0.50
RIGHT_MARGIN=0.50
BOTTOM_MARGIN=0.35

HEADER_HEIGHT=1.35
#BODY_HEIGHT=8.40

HEADER_TOP=$(TOP_MARGIN)

BODY___TOP=$(shell echo "$(HEADER_HEIGHT) + $(HEADER_TOP)" | bc)
#FOOTER_TOP=$(shell echo "$(BODY_HEIGHT) + $(BODY___TOP) + $(HEADER_TOP)" | bc)

HEADER_GEOMETRY="top=$(HEADER_TOP)in, bottom=$(BOTTOM_MARGIN)in, left=$(LEFT_MARGIN)in, right=$(RIGHT_MARGIN)in"
BODY___GEOMETRY="top=$(BODY___TOP)in, bottom=0.70in, left=$(LEFT_MARGIN)in, right=$(RIGHT_MARGIN)in"
#FOOTER_GEOMETRY="top=$(FOOTER_TOP)in, bottom=0.00in, left=$(LEFT_MARGIN)in, right=$(RIGHT_MARGIN)in"

BODY=body.md
HEADER=header.md
FOOTER=footer.md
BUILD_DIR=build
STEPS_DIR=build/steps

all: builddir pdf html resume

latextemplate:
	#
	# Combine latex preamble, template, and postamble
	#
	cat templates/base/preamble.latex templates/header.latex templates/base/postamble.latex > $(STEPS_DIR)/header_template.latex
	#cat templates/base/preamble.latex templates/body.latex templates/base/postamble.latex > $(STEPS_DIR)/body_template.latex
	#cat templates/base/preamble.latex templates/footer.latex templates/base/postamble.latex > $(STEPS_DIR)/footer_template.latex

latex: latextemplate
	#
	# Create latex file with markdown context
	#
	pandoc --quiet --template $(STEPS_DIR)/header_template.latex --variable geometry=$(HEADER_GEOMETRY) -o $(STEPS_DIR)/header.latex $(HEADER) --from markdown+raw_attribute
	#pandoc --quiet --template $(STEPS_DIR)/body_template.latex   --variable geometry=$(BODY___GEOMETRY) -o $(STEPS_DIR)/body.latex $(BODY)
	#pandoc --quiet --template $(STEPS_DIR)/footer_template.latex --variable geometry=$(FOOTER_GEOMETRY) -o $(STEPS_DIR)/footer.latex $(FOOTER)


pdf: latex
	#
	# Convert latex to pdf
	#
	pdflatex -jobname=$(STEPS_DIR)/header $(STEPS_DIR)/header.latex >/dev/null
	#pdflatex -jobname=$(STEPS_DIR)/body $(STEPS_DIR)/body.latex >/dev/null
	#pdflatex -jobname=$(STEPS_DIR)/footer $(STEPS_DIR)/footer.latex >/dev/null

resume: pdf
	#
	# Combine pdfs into 1 resume
	#
	cp $(STEPS_DIR)/header.pdf $(BUILD_DIR)/resume.pdf
	echo "done"
	#pdftk $(STEPS_DIR)/header.pdf background $(STEPS_DIR)/body.pdf output $(BUILD_DIR)/resume.pdf
	#pdftk $(STEPS_DIR)/1.pdf background $(STEPS_DIR)/footer.pdf output $(BUILD_DIR)/resume.pdf
	#
	# Cleanup
	#


html:
	pandoc -o $(STEPS_DIR)header.html $(HEADER)
	pandoc -o $(STEPS_DIR)body.html $(BODY)
	#pandoc -o $(STEPS_DIR)footer.html $(FOOTER)

builddir:
	@mkdir -p $(STEPS_DIR)
