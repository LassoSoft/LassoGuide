# Makefile for Sphinx documentation
# modified for LassoGuide

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =
BUILDDIR      = build
TODAY := $(shell touch source/index.rst)

# Internal variables.
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d $(BUILDDIR)/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source
# the i18n builder cannot share the environment and doctrees with the others
I18NSPHINXOPTS  = $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) source

LATEXRGB = -b latex -D pygments_style=latexstyle.LatexStyle
LATEXBW  = -b latex -D pygments_style=latexbwstyle.LatexBWStyle

.PHONY: help clean pdfdownload html dirhtml singlehtml pickle json htmlhelp qthelp devhelp epub latex-common latex latexpdf latexpdfhc latexpdfpb latexpdfvol1 latexpdfvol2 latexpdfvol3 latexpdfvols text man changes linkcheck doctest gettext

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html       to make standalone HTML files"
	@echo "  dirhtml    to make HTML files named index.html in directories"
	@echo "  singlehtml to make a single large HTML file"
	@echo "  pickle     to make pickle files"
	@echo "  json       to make JSON files"
	@echo "  htmlhelp   to make HTML files and a HTML help project"
	@echo "  qthelp     to make HTML files and a qthelp project"
	@echo "  devhelp    to make HTML files and a Devhelp project"
	@echo "  epub       to make an epub"
	@echo "  latex      to make LaTeX files, you can set PAPER=a4 or PAPER=letter"
	@echo "  latexpdf   to make LaTeX files and run them through pdflatex"
	@echo "  text       to make text files"
	@echo "  man        to make manual pages"
	@echo "  texinfo    to make Texinfo files"
	@echo "  info       to make Texinfo files and run them through makeinfo"
	@echo "  gettext    to make PO message catalogs"
	@echo "  changes    to make an overview of all changed/added/deprecated items"
	@echo "  linkcheck  to check all external links for integrity"
	@echo "  doctest    to run all doctests embedded in the documentation (if enabled)"

clean:
	-rm -rf $(BUILDDIR)/*

pdfdownload: $(wildcard $(BUILDDIR)/LassoGuide9*.pdf)
	-rsync -aq $(BUILDDIR)/LassoGuide9*.pdf $(BUILDDIR)/html/

html: pdfdownload
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) $(BUILDDIR)/html
	-rm -rf $(BUILDDIR)/html/_latex
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/html."

dirhtml:
	$(SPHINXBUILD) -b dirhtml $(ALLSPHINXOPTS) $(BUILDDIR)/dirhtml
	@echo
	@echo "Build finished. The HTML pages are in $(BUILDDIR)/dirhtml."

singlehtml:
	$(SPHINXBUILD) -b singlehtml $(ALLSPHINXOPTS) $(BUILDDIR)/singlehtml
	@echo
	@echo "Build finished. The HTML page is in $(BUILDDIR)/singlehtml."

pickle:
	$(SPHINXBUILD) -b pickle $(ALLSPHINXOPTS) $(BUILDDIR)/pickle
	@echo
	@echo "Build finished; now you can process the pickle files."

json:
	$(SPHINXBUILD) -b json $(ALLSPHINXOPTS) $(BUILDDIR)/json
	@echo
	@echo "Build finished; now you can process the JSON files."

htmlhelp:
	$(SPHINXBUILD) -b htmlhelp $(ALLSPHINXOPTS) $(BUILDDIR)/htmlhelp
	@echo
	@echo "Build finished; now you can run HTML Help Workshop with the" \
	      ".hhp project file in $(BUILDDIR)/htmlhelp."

qthelp:
	$(SPHINXBUILD) -b qthelp $(ALLSPHINXOPTS) $(BUILDDIR)/qthelp
	@echo
	@echo "Build finished; now you can run "qcollectiongenerator" with the" \
	      ".qhcp project file in $(BUILDDIR)/qthelp, like this:"
	@echo "# qcollectiongenerator $(BUILDDIR)/qthelp/LassoGuide.qhcp"
	@echo "To view the help file:"
	@echo "# assistant -collectionFile $(BUILDDIR)/qthelp/LassoGuide.qhc"

devhelp:
	$(SPHINXBUILD) -b devhelp $(ALLSPHINXOPTS) $(BUILDDIR)/devhelp
	@echo
	@echo "Build finished."
	@echo "To view the help file:"
	@echo "# mkdir -p $$HOME/.local/share/devhelp/LassoGuide"
	@echo "# ln -s $(BUILDDIR)/devhelp $$HOME/.local/share/devhelp/LassoGuide"
	@echo "# devhelp"

epub:
	$(SPHINXBUILD) -b epub $(ALLSPHINXOPTS) $(BUILDDIR)/epub
	@echo
	@echo "Build finished. The epub file is in $(BUILDDIR)/epub."

latex-common:
	@echo "Changing PDF Makefile to use XeLaTeX instead of pdfLaTeX"
	awk '{gsub(/pdflatex/,"xelatex")}; 1' $(BUILDDIR)/latex/Makefile > $(BUILDDIR)/latex/Makefile2
	mv -f $(BUILDDIR)/latex/Makefile{2,}
	@echo "Implementing ugly hack to fix spacing of content inside descriptions using style=nextline and add columns to LCAPI ref..."
	awk '{gsub(/leavevmode\\begin/,"leavevmode\\vspace*{-1.2\\baselineskip}\\begin");gsub(/emph{Enums}\\begin{quote}/,"emph{Enums}\\begin{quote}\\begin{multicols}{2}");gsub(/\\textbf{datasource\\_action\\_t/,"\\end{multicols}\\textbf{datasource\\_action\\_t")}; 1' $(BUILDDIR)/latex/LassoGuide9.2.tex | sed '/leavevmode$$/{N;s/\n\s*$$//;}' > $(BUILDDIR)/latex/LassoGuide9.2.temp
	mv -f $(BUILDDIR)/latex/LassoGuide9.2.{temp,tex}

latex:
	$(SPHINXBUILD) $(LATEXRGB) $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	make latex-common
	@echo
	@echo "Build finished; the LaTeX files are in $(BUILDDIR)/latex."
	@echo "Run \`make' in that directory to run these through XeLaTeX" \
	      "(use \`make latexpdf' here to do that automatically)."

# PDF for screen
latexpdf:
	$(SPHINXBUILD) $(LATEXRGB) -t screen $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	make latex-common
	@echo "Running LaTeX files through XeLaTeX..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	mv -f $(BUILDDIR)/{latex/,}LassoGuide9.2.pdf
	@echo "XeLaTeX finished; the PDF files are in $(BUILDDIR)/latex."

# PDF for hardcover edition
latexpdfhc:
	$(SPHINXBUILD) $(LATEXRGB) -t hardcover -D latex_elements.cmappkg='\newcommand\isbn{978-0-9936363-1-8}' $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	make latex-common
	@echo "Running LaTeX files through XeLaTeX..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	mv -f $(BUILDDIR)/latex/LassoGuide{9.2,,-Hardcover-9.2}.pdf
	@echo "XeLaTeX finished; the PDF files are in $(BUILDDIR)/latex."

# PDF for paperback edition
latexpdfpb:
	$(SPHINXBUILD) $(LATEXBW) -t paperback -D latex_elements.cmappkg='\newcommand\isbn{978-0-9936363-0-1}' $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	make latex-common
	@echo "Running LaTeX files through XeLaTeX..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	mv -f $(BUILDDIR)/latex/LassoGuide{9.2,-Paperback-9.2-pre}.pdf
	@echo "XeLaTeX finished; the PDF files are in $(BUILDDIR)/latex."
	@echo "Resave using Quartz Filter --> Gray Tone in Preview to create a grayscale PDF."

# PDF for paperback edition volume 1
latexpdfvol1:
	$(SPHINXBUILD) $(LATEXBW) -t paperback -t volume1 -D latex_elements.cmappkg='\newcommand\isbn{978-0-9936363-2-5}' $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	make latex-common
	@echo "Running LaTeX files through XeLaTeX..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	mv -f $(BUILDDIR)/latex/LassoGuide{9.2,-Volume1-9.2-pre}.pdf
	@echo "XeLaTeX finished; the PDF files are in $(BUILDDIR)/latex."
	@echo "Resave using Quartz Filter --> Gray Tone in Preview to create a grayscale PDF."

# PDF for paperback edition volume 2
latexpdfvol2:
	$(SPHINXBUILD) $(LATEXBW) -t paperback -t volume2 -D latex_elements.cmappkg='\newcommand\isbn{978-0-9936363-3-2}' $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	make latex-common
	@echo "Running LaTeX files through XeLaTeX..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	mv -f $(BUILDDIR)/latex/LassoGuide{9.2,-Volume2-9.2-pre}.pdf
	@echo "XeLaTeX finished; the PDF files are in $(BUILDDIR)/latex."
	@echo "Resave using Quartz Filter --> Gray Tone in Preview to create a grayscale PDF."

# PDF for paperback edition volume 3
latexpdfvol3:
	$(SPHINXBUILD) $(LATEXBW) -t paperback -t volume3 -D latex_elements.cmappkg='\newcommand\isbn{978-0-9936363-4-9}' $(ALLSPHINXOPTS) $(BUILDDIR)/latex
	make latex-common
	@echo "Running LaTeX files through XeLaTeX..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	mv -f $(BUILDDIR)/latex/LassoGuide{9.2,-Volume3-9.2-pre}.pdf
	@echo "XeLaTeX finished; the PDF files are in $(BUILDDIR)/latex."
	@echo "Resave using Quartz Filter --> Gray Tone in Preview to create a grayscale PDF."

# PDFs for 3-volume paperback edition
latexpdfvols: latexpdfvol1 latexpdfvol2 latexpdfvol3

text:
	$(SPHINXBUILD) -b text $(ALLSPHINXOPTS) $(BUILDDIR)/text
	@echo
	@echo "Build finished. The text files are in $(BUILDDIR)/text."

man:
	$(SPHINXBUILD) -b man $(ALLSPHINXOPTS) $(BUILDDIR)/man
	@echo
	@echo "Build finished. The manual pages are in $(BUILDDIR)/man."

texinfo:
	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)/texinfo
	@echo
	@echo "Build finished. The Texinfo files are in $(BUILDDIR)/texinfo."
	@echo "Run \`make' in that directory to run these through makeinfo" \
	      "(use \`make info' here to do that automatically)."

info:
	$(SPHINXBUILD) -b texinfo $(ALLSPHINXOPTS) $(BUILDDIR)/texinfo
	@echo "Running Texinfo files through makeinfo..."
	make -C $(BUILDDIR)/texinfo info
	@echo "makeinfo finished; the Info files are in $(BUILDDIR)/texinfo."

gettext:
	$(SPHINXBUILD) -b gettext $(I18NSPHINXOPTS) $(BUILDDIR)/locale
	@echo
	@echo "Build finished. The message catalogs are in $(BUILDDIR)/locale."

changes:
	$(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) $(BUILDDIR)/changes
	@echo
	@echo "The overview file is in $(BUILDDIR)/changes."

linkcheck:
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) $(BUILDDIR)/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	      "or in $(BUILDDIR)/linkcheck/output.txt."

doctest:
	$(SPHINXBUILD) -b doctest $(ALLSPHINXOPTS) $(BUILDDIR)/doctest
	@echo "Testing of doctests in the sources finished, look at the " \
	      "results in $(BUILDDIR)/doctest/output.txt."
