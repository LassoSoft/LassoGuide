Lasso Guide
===========

The goal of the Lasso Guide project is to have a central, authoritative, plain-text package of documentation for Lasso 9 that can be collaboratively viewed and edited, and processed into HTML, PDF, or any other format. The base docs are in the plain-text [reStructuredText (reST)](http://docutils.sourceforge.net/docs/user/rst/quickref.html) format, and use the [Sphinx](http://sphinx-doc.org/) documentation processor to generate HTML and PDF versions.

These build instructions assume you're running Mac OS X, though building on Linux should also be possible.

Environment Setup
-----------------

Before building, you'll need Xcode installed and a [Python development environment](https://hackercodex.com/guide/python-development-environment-on-mac-osx/) set up. Ideally, use [Homebrew](http://brew.sh/) to install Python 3 and virtualenv. Then use `pip` to install these packages:

* [Pygments](http://pygments.org) for syntax highlighting: `pip install pygments`
* [Sphinx](http://sphinx-doc.org/) for HTML generation: `pip install sphinx`
* [Lasso domain](https://pythonhosted.org/sphinxcontrib-lassodomain/) for Sphinx: `pip install sphinxcontrib-lassodomain`
* [breathe](http://breathe.readthedocs.org/en/latest/) for building the LCAPI reference page: `pip install breathe`

Building as HTML
----------------

After checking out this repo in a new Terminal, enter it and build:

```
cd ~/path/to/LassoGuide/
make html
```

If you have the required packages installed, you should get a "Build finished" message, indicating the new HTML site is available in `LassoGuide/build/html/`.

Building as PDF
---------------

You'll need some extra tools to accomplish this. On OS X, you have two options:

1. Install the [MacTeX package](http://tug.org/mactex/), which is a *HUGE* installation—the installer alone is over 2GB. If you're so inclined, you can just grab & install that and be done. 
2. But if you'd like to be a bit more selective, just get [BasicTeX](http://tug.org/mactex/morepackages.html ) and use the `tlmgr` command to install the additional packages below.

```
sudo tlmgr update --self
sudo tlmgr update --all
sudo tlmgr install titlesec framed threeparttable wrapfig multirow everypage enumitem tocloft microtype capt-of needspace
```

The following fonts are also required:

- Myriad Pro
- Consolas (bundled with MS Office)
- Arial Unicode MS (pre-installed with OS X)

If any of these fonts are installed in your home folder at `~/Library/Fonts/` instead of in `/Library/Fonts/`, you'll need to download and open the [TeX Live Utility](https://www.tug.org/mactex/morepackages.html), open Preferences, and check "Automatically enable fonts in my home directory".

Then run `make latexpdf` to create a PDF in the `LassoGuide/build/latex/` folder.

More info:
 
* http://tex.stackexchange.com/questions/974/why-is-the-mactex-distribution-so-large-is-there-anything-smaller-for-os-x
* http://en.wikibooks.org/wiki/LaTeX/

### Updating vector resources

Some items in the `_static` folder exist in both SVG and PDF forms. If you update an SVG file, you'll need to recreate its PDF version. If you don't have `rsvg-convert`, use homebrew to install `librsvg`, then regenerate the PDF version with:

```
rsvg-convert -f pdf file_name.svg -o file_name.pdf
```

By using a directive like `.. image:: /_static/file_name.*`, Sphinx will pick an appropriate file format for the target you're building; in this case, SVG for HTML, and PDF for Latex.

The syntax diagrams were created in OmniGraffle 5 and exported to SVG. Something goes awry with the arrowheads when converting to PDF causing them to appear off-center, but according to [this forum post](http://forums.omnigroup.com/archive/index.php/t-2456.html) all you need to do is edit the SVG file and change x & y to 0 for each marker's `viewBox="x y a b"`. Also, Helvetica doesn't convert well to PDF, so use Arial instead.

Writing in reStructuredText
---------------------------

The reST markup language, bundled with the [Docutils](http://docutils.sourceforge.net/) package, is made for marking up single documents; Sphinx then adds reST-like [markup constructs](http://www.sphinx-doc.org/en/stable/markup/index.html) for multipage, programming-related documentation. Below are some resources for writing reST:

* http://docutils.sourceforge.net/docs/user/rst/quickref.html
* http://www.sphinx-doc.org/en/stable/rest.html
* https://raw.github.com/ralsina/rst-cheatsheet/master/rst-cheatsheet.pdf - PDF cheat sheet
* http://rst.ninjs.org/ - online reST editor

Syntax highlighting of reST is available in [Sublime Text](http://sublimetext.com/), [BBEdit and TextWrangler](http://barebones.com/products/) via [plugin](https://bitbucket.org/EricFromCanada/ericfromcanada.bitbucket.org/raw/default/bbedit/reStructuredText.plist), and [many other text editors](http://stackoverflow.com/questions/2746692/restructuredtext-tool-support). 

### Previewing with restview

Use [restview](http://mg.pov.lt/restview/) to get a real-time HTML preview of the file you're working on. It doesn't currently support any of Sphinx's directives, however.

After installing with `pip install restview`, pass it a folder of reST files:

```
cd ~/path/to/LassoGuide/
restview -l localhost:5555 source/
```

and open http://localhost:5555/ in a web browser.

BBEdit can be configured to automatically preview the current document using restview. In version 10.5 or later:

1. create a new Project for LassoGuide's `source` folder
1. in the project's Site Settings (under the cloud icon), set the following:
	* Local site root: full path to `LassoGuide/source/`
	* Use local preview server: enabled and set to http://localhost:5555/

Then with a reST file open and `restview` running in Terminal, select Markup > Preview in BBEdit to open a self-updating HTML preview of the file.
