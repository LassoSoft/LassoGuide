Lasso Guide
===========

The goal of the Lasso Guide project is to have a central, authoritative, plain-text package of documentation for Lasso 9 that can be collaboratively viewed and edited, and processed into HTML, PDF, or any other format. The base docs are in the plain-text [reStructuredText (reST)](http://docutils.sourceforge.net/docs/user/rst/quickref.html) format, and use the [Sphinx](http://sphinx-doc.org/) documentation processor to generate HTML and PDF versions.

These build instructions assume you're running Mac OS X, though building on Linux should also be possible.

Environment Setup
-----------------

Before building, you'll need Xcode installed and a Python development environment set up. Ideally, use [Homebrew](http://brew.sh/) to install Python 3 and virtualenv. Then use `pip` to install these packages:

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
