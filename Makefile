# Makefile for Sphinx documentation
# modified for LassoGuide

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build

# User-friendly check for sphinx-build
ifeq ($(shell which $(SPHINXBUILD) >/dev/null 2>&1; echo $$?), 1)
$(error The '$(SPHINXBUILD)' command was not found. Make sure you have Sphinx installed, then set the SPHINXBUILD environment variable to point to the full path of the '$(SPHINXBUILD)' executable. Alternatively you can add the directory with the executable to your PATH. If you don't have Sphinx installed, grab it from http://sphinx-doc.org/)
endif

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

LATEXRGB = -D pygments_style=latextracstyle.LatexTracStyle
LATEXBW  = -D pygments_style=latexbwstyle.LatexBWStyle
VERSION  = 9.2
TODAY := $(shell touch source/index*.rst)

.PHONY: help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html       to make standalone HTML files"
	@echo "  dirhtml    to make HTML files named index.html in directories"
	@echo "  singlehtml to make a single large HTML file"
	@echo "  pickle     to make pickle files"
	@echo "  json       to make JSON files"
	@echo "  htmlhelp   to make HTML files and a HTML help project"
	@echo "  qthelp     to make HTML files and a qthelp project"
	@echo "  applehelp  to make an Apple Help Book"
	@echo "  devhelp    to make HTML files and a Devhelp project"
	@echo "  epub       to make an epub"
	@echo "  latex      to make LaTeX files, you can set PAPER=a4 or PAPER=letter"
	@echo "  latexpdf   to make LaTeX files and run them through pdflatex"
	@echo "  latexpdfja to make LaTeX files and run them through platex/dvipdfmx"
	@echo "  text       to make text files"
	@echo "  man        to make manual pages"
	@echo "  texinfo    to make Texinfo files"
	@echo "  info       to make Texinfo files and run them through makeinfo"
	@echo "  gettext    to make PO message catalogs"
	@echo "  changes    to make an overview of all changed/added/deprecated items"
	@echo "  xml        to make Docutils-native XML files"
	@echo "  pseudoxml  to make pseudoxml-XML files for display purposes"
	@echo "  linkcheck  to check all external links for integrity"
	@echo "  doctest    to run all doctests embedded in the documentation (if enabled)"
	@echo "  coverage   to run coverage check of the documentation (if enabled)"

.PHONY: clean
clean:
	rm -rf $(BUILDDIR)/*

.PHONY: LassoGuide$(VERSION).pdf
LassoGuide$(VERSION).pdf:
	@-rsync -aq $(BUILDDIR)/LassoGuide$(VERSION).pdf $(BUILDDIR)/html/

.PHONY: html
html: LassoGuide$(VERSION).pdf
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	@rm -rf $(BUILDDIR)/html/_latex  $(BUILDDIR)/html/_sources/_latex
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

.PHONY: dirhtml
dirhtml:
	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/dirhtml."

.PHONY: singlehtml
singlehtml:
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/singlehtml
	@echo
	@echo "Build finished. The HTML page is in $(BUILDDIR)/singlehtml."

.PHONY: pickle
pickle:
	$(SPHINXBUILD) -b pickle $(ALLSPHINXOPTS) $(BUILDDIR)/pickle
	@echo
	@echo "Build finished; now you can process the pickle files."

.PHONY: json
json:
	$(SPHINXBUILD) -b json $(ALLSPHINXOPTS) $(BUILDDIR)/json
	@echo
	@echo "Build finished; now you can process the JSON files."

.PHONY: htmlhelp
htmlhelp:
	$(SPHINXBUILD) -b htmlhelp $(ALLSPHINXOPTS) $(BUILDDIR)/htmlhelp
	@echo
	@echo "Build finished; now you can run HTML Help Workshop with the" \
	      ".hhp project file in $(BUILDDIR)/htmlhelp."

.PHONY: qthelp
qthelp:
	$(SPHINXBUILD) -b qthelp $(ALLSPHINXOPTS) $(BUILDDIR)/qthelp
	@echo
	@echo "Build finished; now you can run "qcollectiongenerator" with the" \
	      ".qhcp project file in $(BUILDDIR)/qthelp, like this:"
	@echo "# qcollectiongenerator $(BUILDDIR)/qthelp/LassoGuide.qhcp"
	@echo "To view the help file:"
	@echo "# assistant -collectionFile $(BUILDDIR)/qthelp/LassoGuide.qhc"

.PHONY: applehelp
applehelp:
	$(SPHINXBUILD) -b applehelp $(ALLSPHINXOPTS) $(BUILDDIR)/applehelp
	@echo
	@echo "Build finished. The help book is in $(BUILDDIR)/applehelp."
	@echo "N.B. You won't be able to view it unless you put it in" \
	      "~/Library/Documentation/Help or install it in your application" \
	      "bundle."

.PHONY: devhelp
devhelp:
	$(SPHINXBUILD) -b devhelp $(ALLSPHINXOPTS) $(BUILDDIR)/devhelp
	@echo
	@echo "Build finished."
	@echo "To view the help file:"
	@echo "# mkdir -p $$HOME/.local/share/devhelp/LassoGuide"
	@echo "# ln -s $(BUILDDIR)/devhelp $$HOME/.local/share/devhelp/LassoGuide"
	@echo "# devhelp"

.PHONY: epub
epub:
	$(SPHINXBUILD) -b epub $(ALLSPHINXOPTS) $(BUILDDIR)/epub
	@echo
	@echo "Build finished. The epub file is in $(BUILDDIR)/epub."

.PHONY: latex-common
latex-common:
	@echo "Changing PDF Makefile to use XeLaTeX instead of pdfLaTeX"
	@awk '{gsub(/pdflatex/,"xelatex")}; 1' $(BUILDDIR)/latex/Makefile > $(BUILDDIR)/latex/Makefile.temp && mv -f $(BUILDDIR)/latex/Makefile{.temp,}
	@echo "Implementing ugly hacks in the .tex file..."
#		1. remove extra space inside descriptions using style=nextline
#		2. add columns to LCAPI ref
#		3. remove space after \leavevmode
#		4. remove horizontal lines from tables
	@awk '\
		/\\leavevmode\\begin/ { gsub(/\\leavevmode\\begin/, "\\leavevmode\\vspace*{-1.2\\baselineskip}\\begin") } \
		/\\paragraph{Enums}/ { gsub(/\\paragraph{Enums}/, "&\n\\begin{multicols}{2}") } \
		/\\begin{fulllineitems}/ { if((getline nextline)>0 && nextline~/{api\/lcapi-reference:c.datasource_action_t}/) { gsub(/\\begin{fulllineitems}/, "\\end{multicols}\n&"); } $$0 = $$0"\n"nextline } \
		1' \$(BUILDDIR)/latex/LassoGuide$(VERSION).tex | sed -E -e '/leavevmode$$/{N;s/\n\s*$$//;}' \
		-e '/^(\\begin\{tab|\\caption|\\\\$$|\{\{\\textsf)/{N;s/\n\\hline//;}' -e '/\{\{\\textsf\{Continued on next page\}\}\}/{s/\|r\|/r/;s/\\hline$$//;}' \
		> $(BUILDDIR)/latex/LassoGuide$(VERSION).temp && mv -f $(BUILDDIR)/latex/LassoGuide$(VERSION).{temp,tex}

.PHONY: latex
latex:
	$(SPHINXBUILD) -b latex $(LATEXRGB) $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	make latex-common
	@echo
	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex."
	@echo "Run \`make' in that directory to run these through XeLaTeX" \
	      "(use \`make latexpdf' here to do that automatically)."

# PDF for screen
.PHONY: latexpdf
latexpdf:
	$(SPHINXBUILD) -b latex $(LATEXRGB) -t screen $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	make latex-common
	@echo "Running LaTeX files through XeLaTeX..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	@mv -f $(BUILDDIR)/{latex/,}LassoGuide$(VERSION).pdf
	@echo "XeLaTeX finished; the PDF files are in $(BUILDDIR)/latex."

# PDF for hardcover edition
.PHONY: latexpdfhc
latexpdfhc:
	$(SPHINXBUILD) -b latex $(LATEXRGB) -t hardcover -D latex_elements.cmappkg='\newcommand\isbn{978-0-9936363-1-8}' $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	make latex-common
	@echo "Running LaTeX files through XeLaTeX..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	@mv -f $(BUILDDIR)/latex/LassoGuide{,-Hardcover-}$(VERSION).pdf
	@echo "XeLaTeX finished; the PDF files are in $(BUILDDIR)/latex."

# PDF for paperback edition
.PHONY: latexpdfpb
latexpdfpb:
	$(SPHINXBUILD) -b latex $(LATEXBW) -t paperback -D latex_elements.cmappkg='\newcommand\isbn{978-0-9936363-0-1}' $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	make latex-common
	@echo "Running LaTeX files through XeLaTeX..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	@mv -f $(BUILDDIR)/latex/LassoGuide{$(VERSION),-Paperback-$(VERSION)-pre}.pdf
	@echo "XeLaTeX finished; the PDF files are in $(BUILDDIR)/latex."
	@echo "Resave using Quartz Filter --> Gray Tone in Preview to create a grayscale PDF."

# PDF for paperback edition volume 1
.PHONY: latexpdfvol1
latexpdfvol1:
	$(SPHINXBUILD) -b latex $(LATEXBW) -t paperback -t volume1 -D latex_elements.cmappkg='\newcommand\isbn{978-0-9936363-2-5}' $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	make latex-common
	@echo "Running LaTeX files through XeLaTeX..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	@mv -f $(BUILDDIR)/latex/LassoGuide{$(VERSION),-Volume1-$(VERSION)-pre}.pdf
	@echo "XeLaTeX finished; the PDF files are in $(BUILDDIR)/latex."
	@echo "Resave using Quartz Filter --> Gray Tone in Preview to create a grayscale PDF."

# PDF for paperback edition volume 2
.PHONY: latexpdfvol2
latexpdfvol2:
	$(SPHINXBUILD) -b latex $(LATEXBW) -t paperback -t volume2 -D latex_elements.cmappkg='\newcommand\isbn{978-0-9936363-3-2}' $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	make latex-common
	@echo "Running LaTeX files through XeLaTeX..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	@mv -f $(BUILDDIR)/latex/LassoGuide{$(VERSION),-Volume2-$(VERSION)-pre}.pdf
	@echo "XeLaTeX finished; the PDF files are in $(BUILDDIR)/latex."
	@echo "Resave using Quartz Filter --> Gray Tone in Preview to create a grayscale PDF."

# PDF for paperback edition volume 3
.PHONY: latexpdfvol3
latexpdfvol3:
	$(SPHINXBUILD) -b latex $(LATEXBW) -t paperback -t volume3 -D latex_elements.cmappkg='\newcommand\isbn{978-0-9936363-4-9}' $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	make latex-common
	@echo "Running LaTeX files through XeLaTeX..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	@mv -f $(BUILDDIR)/latex/LassoGuide{$(VERSION),-Volume3-$(VERSION)-pre}.pdf
	@echo "XeLaTeX finished; the PDF files are in $(BUILDDIR)/latex."
	@echo "Resave using Quartz Filter --> Gray Tone in Preview to create a grayscale PDF."

# PDFs for 3-volume paperback edition
.PHONY: latexpdfvols
latexpdfvols: latexpdfvol1 latexpdfvol2 latexpdfvol3

.PHONY: latexpdfja
latexpdfja:
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	@echo "Running LaTeX files through platex and dvipdfmx..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf-ja
	@echo "pdflatex finished; the PDF files are in $(BUILDDIR)/latex."

.PHONY: text
text:
	$(SPHINXBUILD) -b text $(ALLSPHINXOPTS) $(BUILDDIR)/text
	@echo
	@echo "Build finished. The text files are in $(BUILDDIR)/text."

.PHONY: man
man:
	$(SPHINXBUILD) -b man $(ALLSPHINXOPTS) $(BUILDDIR)/man
	@echo
	@echo "Build finished. The manual pages are in $(BUILDDIR)/man."

.PHONY: texinfo
texinfo:
	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)/texinfo
	@echo
	@echo "Build finished. The Texinfo files are in $(BUILDDIR)/texinfo."
	@echo "Run \`make' in that directory to run these through makeinfo" \
	      "(use \`make info' here to do that automatically)."

.PHONY: info
info:
	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)/texinfo
	@echo "Running Texinfo files through makeinfo..."
	make -C $(BUILDDIR)/texinfo info
	@echo "makeinfo finished; the Info files are in $(BUILDDIR)/texinfo."

.PHONY: gettext
gettext:
	$(SPHINXBUILD) -b gettext $(I18NSPHINXOPTS) $(BUILDDIR)/locale
	@echo
	@echo "Build finished. The message catalogs are in $(BUILDDIR)/locale."

.PHONY: changes
changes:
	$(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)/changes
	@echo
	@echo "The overview file is in $(BUILDDIR)/changes."

.PHONY: linkcheck
linkcheck:
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

.PHONY: doctest
doctest:
	$(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)/doctest
	@echo "Testing of doctests in the sources finished, look at the " \
	      "results in $(BUILDDIR)/doctest/output.txt."

.PHONY: coverage
coverage:
	$(SPHINXBUILD) -b coverage $(ALLSPHINXOPTS) $(BUILDDIR)/coverage
	@echo "Testing of coverage in the sources finished, look at the " \
	      "results in $(BUILDDIR)/coverage/python.txt."

.PHONY: xml
xml:
	$(SPHINXBUILD) -b xml $(ALLSPHINXOPTS) $(BUILDDIR)/xml
	@echo
	@echo "Build finished. The XML files are in $(BUILDDIR)/xml."

.PHONY: pseudoxml
pseudoxml:
	$(SPHINXBUILD) -b pseudoxml $(ALLSPHINXOPTS) $(BUILDDIR)/pseudoxml
	@echo
	@echo "Build finished. The pseudo-XML files are in $(BUILDDIR)/pseudoxml."
