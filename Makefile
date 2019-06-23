HEADER_GEOMETRY="top=0.60in, bottom=0.60in, left=0.60in, right=0.60in"
BODY___GEOMETRY="top=5.95in, bottom=1.00in, left=0.60in, right=0.60in"
FOOTER_GEOMETRY="top=10.0in, bottom=0.00in, left=0.60in, right=0.60in"

BODY=body.md
HEADER=header.md
FOOTER=footer.md
BUILD_DIR=build/
STEPS_DIR=build/steps/

all: builddir pdf html resume

latex: latextemplate
	#
	# Create latex file with markdown context
	#
	pandoc --quiet --template $(STEPS_DIR)header_template.latex --variable geometry=$(HEADER_GEOMETRY) -o $(STEPS_DIR)header.latex $(HEADER)
	pandoc --quiet --template $(STEPS_DIR)body_template.latex   --variable geometry=$(BODY___GEOMETRY) -o $(STEPS_DIR)body.latex $(BODY)
	pandoc --quiet --template $(STEPS_DIR)footer_template.latex --variable geometry=$(FOOTER_GEOMETRY) -o $(STEPS_DIR)footer.latex $(FOOTER)

latextemplate:
	#
	# Combine latex preamble, template, and postamble
	#
	cat templates/base/preamble.latex templates/header.latex templates/base/postamble.latex > $(STEPS_DIR)header_template.latex
	cat templates/base/preamble.latex templates/body.latex templates/base/postamble.latex > $(STEPS_DIR)body_template.latex
	cat templates/base/preamble.latex templates/footer.latex templates/base/postamble.latex > $(STEPS_DIR)footer_template.latex

pdf: latex
	#
	# Convert latex to pdf
	#
	pdflatex -jobname=$(STEPS_DIR)header $(STEPS_DIR)header.latex >/dev/null
	pdflatex -jobname=$(STEPS_DIR)body $(STEPS_DIR)body.latex >/dev/null
	pdflatex -jobname=$(STEPS_DIR)footer $(STEPS_DIR)footer.latex >/dev/null

resume: pdf
	#
	# Combine pdfs into 1 resume
	#
	pdftk $(STEPS_DIR)header.pdf background $(STEPS_DIR)body.pdf output $(STEPS_DIR)1.pdf
	pdftk $(STEPS_DIR)1.pdf background $(STEPS_DIR)footer.pdf output $(BUILD_DIR)resume.pdf


html:
	pandoc -o $(STEPS_DIR)header.html $(HEADER)
	pandoc -o $(STEPS_DIR)body.html $(BODY)
	pandoc -o $(STEPS_DIR)footer.html $(FOOTER)

builddir:
	@mkdir -p $(STEPS_DIR)
