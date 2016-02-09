# -*- coding: utf-8 -*-
#
# LassoGuide documentation build configuration file, created by
# sphinx-quickstart on Wed Oct 24 16:16:59 2012.
#
# This file is execfile()d with the current directory set to its containing dir.
#
# Note that not all possible configuration values are present in this
# autogenerated file.
#
# All configuration values have a default; values that are commented out
# serve to show the default.

import sys, os, time
#sys.path.append(os.path.abspath('_templates'))

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
sys.path.insert(0, os.path.abspath('_latex'))
import latextracstyle, latexbwstyle

# -- General configuration -----------------------------------------------------

# If your documentation needs a minimal Sphinx version, state it here.
needs_sphinx = '1.3'

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx.ext.ifconfig',
    'sphinxcontrib.lassodomain',
    'breathe',
]
needs_extensions = {'breathe': '4'}

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# The suffix of source filenames.
source_suffix = '.rst'

# The encoding of source files.
#source_encoding = 'utf-8-sig'

# The master toctree document.
master_doc = 'index'

# General information about the project.
project = u'LassoGuide'
copyright = u'%s, LassoSoft Inc.' % time.strftime('%Y')

# The version info for the project you're documenting, acts as replacement for
# |version| and |release|, also used in various other places throughout the
# built documents.
#
# The short X.Y version.
version = '9.2'
# The full version, including alpha/beta/rc tags.
release = '9.2'

# The language for content autogenerated by Sphinx. Refer to documentation
# for a list of supported languages.
#language = None

# There are two options for replacing |today|: either, you set today to some
# non-false value, then it is used:
#today = ''
# Else, today_fmt is used as the format for a strftime call.
#today_fmt = '%B %d, %Y'

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
exclude_patterns = ['.git*', 'glossary.rst', '_includes']

# The reST default role (used for this markup: `text`) to use for all documents.
default_role = 'meth'

# If true, '()' will be appended to :func: etc. cross-reference text.
add_function_parentheses = False

# If true, the current module name will be prepended to all description
# unit titles (such as .. function::).
#add_module_names = True

# If true, sectionauthor and moduleauthor directives will be shown in the
# output. They are ignored by default.
#show_authors = False

# The name of the Pygments (syntax highlighting) style to use.
pygments_style = 'trac'

# A list of ignored prefixes for module index sorting.
#modindex_common_prefix = []

# The default language for syntax coloring
highlight_language='html+lasso'
highlight_options = {'builtinshighlighting' : False}

# The default domain for reference definitions
primary_domain = 'ls'

# workaround for https://github.com/sphinx-doc/sphinx/issues/580
rst_epilog = """
.. |dot| unicode:: 0x2E
   :trim:
"""

# -- Breathe Options
breathe_projects = { "LCAPI": os.path.abspath("../doxygen/xml/") }
breathe_default_project = "LCAPI"
breathe_domain_by_extension = { "h" : "c" }


# -- Options for HTML output ---------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
html_theme = 'amphibious'

# Theme options are theme-specific and customize the look and feel of a theme
# further.  For a list of options available for each theme, see the
# documentation.
#html_theme_options = {}

# Add any paths that contain custom themes here, relative to this directory.
html_theme_path = ['_themes']

# The name for this set of Sphinx documents.  If None, it defaults to
# "<project> v<release> documentation".
#html_title = None

# A shorter title for the navigation bar.  Default is the same as html_title.
#html_short_title = None

# The name of an image file (relative to this directory) to place at the top
# of the sidebar.
#html_logo = None

# The name of an image file (within the static path) to use as favicon of the
# docs.  This file should be a Windows icon file (.ico) being 16x16 or 32x32
# pixels large.
html_favicon = '_static/favicon.ico'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# If not '', a 'Last updated on:' timestamp is inserted at every page bottom,
# using the given strftime format.
html_last_updated_fmt = '%b %d, %Y'

# If true, SmartyPants will be used to convert quotes and dashes to
# typographically correct entities.
#html_use_smartypants = True

# Custom sidebar templates, maps document names to template names.
#html_sidebars = {}

# Additional templates that should be rendered to pages, maps page names to
# template names.
#html_additional_pages = {}

# If false, no module index is generated.
#html_domain_indices = True

# If false, no index is generated.
#html_use_index = True

# If true, the index is split into individual pages for each letter.
#html_split_index = False

# If true, links to the reST sources are added to the pages.
#html_show_sourcelink = True

# If true, "Created using Sphinx" is shown in the HTML footer. Default is True.
#html_show_sphinx = True

# If true, "(C) Copyright ..." is shown in the HTML footer. Default is True.
#html_show_copyright = True

# If true, an OpenSearch description file will be output, and all pages will
# contain a <link> tag referring to it.  The value of this option must be the
# base URL from which the finished HTML is served.
html_use_opensearch = 'http://lassoguide.com/'

# This is the file name suffix for HTML files (e.g. ".xhtml").
#html_file_suffix = None

# Output file base name for HTML help builder.
htmlhelp_basename = 'LassoGuide-doc'


# -- Options for LaTeX output --------------------------------------------------

latex_elements = {
# Unused by XeLaTeX, so we commandeer it to set the ISBN
'cmappkg': '\\newcommand\\isbn{000-0-0000000-0-0}',

# The paper size ('letterpaper' or 'a4paper').
'papersize': 'letterpaper',

# The font size ('10pt', '11pt' or '12pt').
'pointsize': '10pt',
'babel': '\\usepackage[english]{babel}',
'inputenc': '',
'utf8extra': '',
'fontpkg': '',
'fncychap': '\\usepackage{fncychap}',
'fontenc': '',

# Need to add blank page at the end for publisher
'printindex': r'\printindex \pagestyle{empty} \clearpage\null\vfill\pagestyle{empty}\par',

# Additional stuff for the LaTeX preamble.
'preamble': r"""
% Font setup (Be sure you have them installed on your machine)
\usepackage[quiet]{fontspec}
\defaultfontfeatures[Myriad Pro Light]{Ligatures=TeX}
\setmainfont[BoldFont={Myriad Pro},SmallCapsFont={Myriad Pro SemiExtended},SmallCapsFeatures={Scale=0.95}]{Myriad Pro Light}
\setsansfont[BoldFont={Myriad Pro},Color=273777]{Myriad Pro Light}
\setmonofont[Scale=0.9]{Consolas}
\usepackage[verbose=silent]{microtype}
\UseMicrotypeSet[protrusion]{basictext}
\SetProtrusion[name=default]
   { encoding = {EU1} }
   { % currently seems only to work with hyphens
      .  = {  ,700},
     {,} = {  ,500},
      :  = {  ,500},
      ;  = {  ,300},
      !  = {  ,100},
      ?  = {  ,100},
      ( = {100,   },
      ) = {   ,200},
      / = {100,200},
      - = {   ,500},
     \textendash       = {200,200},   \textemdash        = {150,150},
     \textquoteleft    = {300,400},   \textquoteright    = {300,400},
     \textquotedblleft = {300,300},   \textquotedblright = {300,300},
   }

% For the Chinese character
\usepackage{xeCJK}
\setCJKmainfont{Arial Unicode MS}
\setCJKsansfont{Arial Unicode MS}
\setCJKmonofont{Arial Unicode MS}

% To make sure figures are placed where we want them
\usepackage{float}
\let\origfigure=\figure
\renewenvironment{figure}[6]{
  \origfigure[H]}
{\endlist}

% Ensure keyword parameters in method signatures don't break after hyphen
\exhyphenpenalty=10000

% Use consistent spacing between words and sentences
\frenchspacing

% Insert line break after definition list terms
% Has the side effect of allowing footnotes inside definition terms
\usepackage{enumitem}
\setlist[description]{style=nextline,leftmargin=1.4em,labelsep=*}
\setlist[enumerate]{labelsep=6pt}
\setlist[itemize]{labelsep=6pt}

% Reduce left margin for quote
\renewenvironment{quote}{
  \list{}{
    \leftmargin=10pt
    \rightmargin\leftmargin
  }\item\relax
}
{\endlist}

% For including other PDF files
\usepackage{pdfpages}

% Style the ToC titles and add space between chapter numbers/titles
\usepackage[titles]{tocloft}
\addtolength{\cftbeforepartskip}{-0.5em}
\addtolength{\cftsecnumwidth}{0.5em}
\newcommand\forewordname{Foreword}

% Make blank pages use empty page style
\let\origdoublepage\cleardoublepage
\renewcommand{\cleardoublepage}{%
  \newpage{\pagestyle{empty}\origdoublepage}%
}

% Adjust table appearance
\setlength{\arrayrulewidth}{0.2pt}
%\setlength{\extrarowheight}{1pt}
\renewcommand{\arraystretch}{1.2}

% For columnizing a section of the LCAPI reference
\usepackage{multicol}

% For making the list of tables show conditionally
\usepackage[table]{totalcount}

\makeatletter

% For some reason, this works to get the default font color
% (Using fontspec never allowed for Sphinx's overrides to kick in.)
\newcommand{\globalcolor}[1]{
  \color{#1}\global\let\default@color\current@color
}

\makeatother
\AtBeginDocument{\globalcolor{BaseColor}}
"""
+ ('\hypersetup{urlcolor=OuterLinkColor}\n' if tags.has('screen') else ''),

# For PdfLaTeX I gave up, but switching to XeLaTeX got it working
# Gave up and used unicode checkmark instead
# This was my best guess for the Chinese character (u4E26):
#\\usepackage{CJK}
#\\usepackage{newunicodechar}
#\\newunicodechar{並}{\\begin{CJK}{UTF8}{bsmi}並\\end{CJK}}
#
# Based on the following:
# http://tex.stackexchange.com/questions/17611/how-does-one-type-chinese-in-latex
#
#http://www.tug.org/pipermail/texhax/2004-January/001476.html
#It may also be a good idea to create a new command :
#   \newcommand{\cjktext}[1]{\begin{CJK}{UTF8}{cyberbit}#1\end{CJK}}
#Now, when you want to type chinese, you just use the command:
#   \cjktext{enter your chinese text here}

# Latex figure (float) alignment
#'figure_align': 'htbp',
}

# Override the default styles with our own.
latex_additional_files = [
  '_static/guide_cover_92.pdf',
  '_latex/sphinx.sty',
  '_latex/sphinxmanual.cls',
]

# Grouping the document tree into LaTeX files. List of tuples
# (source start file, target name, title, author, documentclass [howto/manual]).
if tags.has('volume1'):
    exclude_patterns.extend(['**/index.rst'])
    latex_documents = [
      ('_latex/index_1', 'LassoGuide9.2.tex', r'\textbf{Lasso}Guide: Language',
       u'LassoSoft Inc.', 'manual'),
    ]
elif tags.has('volume2'):
    exclude_patterns.extend(['**/index.rst'])
    latex_documents = [
      ('_latex/index_2', 'LassoGuide9.2.tex', r'\textbf{Lasso}Guide: Applications',
       u'LassoSoft Inc.', 'manual'),
    ]
elif tags.has('volume3'):
    exclude_patterns.extend(['**/index.rst'])
    latex_documents = [
      ('_latex/index_3', 'LassoGuide9.2.tex', r'\textbf{Lasso}Guide: API',
       u'LassoSoft Inc.', 'manual'),
    ]
else:
    exclude_patterns.extend(['**/index_[123].rst'])
    latex_documents = [
      ('_latex/index', 'LassoGuide9.2.tex', r'\textbf{Lasso}Guide',
       u'LassoSoft Inc.', 'manual'),
    ]

# The name of an image file (relative to this directory) to place at the top of
# the title page.
#latex_logo = '_static/guide_cover_92.jpg' if tags.has('screen') else None

# For "manual" documents, if this is true, then toplevel headings are parts,
# not chapters.
latex_use_parts = True

# If true, show page references after internal links.
#latex_show_pagerefs = False

# If true, show URL addresses after external links.
latex_show_urls = 'footnote'

# Documents to append as an appendix to all manuals.
#latex_appendices = []

# If false, no module index is generated.
#latex_domain_indices = True


# -- Options for manual page output --------------------------------------------

# One entry per manual page. List of tuples
# (source start file, name, description, authors, manual section).
man_pages = [
  ('index', 'lassoguide', u'LassoGuide', [u'LassoSoft Inc.'], 1)
]

# If true, show URL addresses after external links.
#man_show_urls = False


# -- Options for Texinfo output ------------------------------------------------

# Grouping the document tree into Texinfo files. List of tuples
# (source start file, target name, title, author,
#  dir menu entry, description, category)
texinfo_documents = [
  ('index', 'LassoGuide', u'LassoGuide',
   u'LassoSoft Inc.', 'LassoGuide', 'Guide to the Lasso language and server.',
   'Miscellaneous'),
]

# Documents to append as an appendix to all manuals.
#texinfo_appendices = []

# If false, no module index is generated.
#texinfo_domain_indices = True

# How to display URL addresses: 'footnote', 'no', or 'inline'.
#texinfo_show_urls = 'footnote'


# -- Options for Epub output ---------------------------------------------------

# Bibliographic Dublin Core info.
epub_title = u'LassoGuide'
epub_author = u'LassoSoft Inc.'
epub_publisher = u'LassoSoft Inc.'
epub_copyright = u'2013, LassoSoft Inc.'

# The language of the text. It defaults to the language option
# or en if the language is not set.
#epub_language = ''

# The scheme of the identifier. Typical schemes are ISBN or URL.
#epub_scheme = ''

# The unique identifier of the text. This can be a ISBN number
# or the project homepage.
#epub_identifier = ''

# A unique identification for the text.
#epub_uid = ''

# A tuple containing the cover image and cover page html template filenames.
#epub_cover = ()

# HTML files that should be inserted before the pages created by sphinx.
# The format is a list of tuples containing the path and title.
#epub_pre_files = []

# HTML files shat should be inserted after the pages created by sphinx.
# The format is a list of tuples containing the path and title.
#epub_post_files = []

# A list of files that should not be packed into the epub file.
#epub_exclude_files = []

# The depth of the table of contents in toc.ncx.
#epub_tocdepth = 3

# Allow duplicate toc entries.
#epub_tocdup = True