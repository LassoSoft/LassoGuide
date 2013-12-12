.. raw:: latex

   \cleardoublepage
   \phantomsection
   \section*{\Huge Welcome to \textbf{Lasso}Guide}
   \addcontentsline{toc}{chapter}{Preface}
   \pagestyle{plain}
   \bigskip
   \begingroup
   \titleformat{\paragraph}{\color{InnerLinkColor}\Large}{}{}{}

Lasso is a powerful programming language used to drive millions of web pages
from servers around the world. It has an easy-to-master syntax and allows fast,
flexible development and scripting. Lasso can be used in many ways, and as a
language, provides a virtually infinite set of shortcuts for achieving
development goals.

This guide is meant to serve as both an introduction and comprehensive manual to
Lasso and Lasso Server |version|. The material in this guide will evolve and
improve along with Lasso. The most up-to-date version of this documentation
containing all improvements can be found at `<http://lassoguide.com/>`_.


.. rubric:: Organization of This Guide

This guide is divided up into eight parts covering all aspects of the Lasso
programming language.

-  :ref:`book-get-start` introduces the basic features of the Lasso language and
   server, as well as instructions for installing and configuring Lasso.

-  :ref:`book-language` covers the syntax and features of the Lasso language.
   Read this thoroughly for a complete understanding of how Lasso code is
   structured.

-  :ref:`book-data`, :ref:`book-input-output`, :ref:`book-development`, and
   :ref:`book-communication` detail the capabilities of the libraries that ship
   with Lasso, divided into appropriate categories. Method definitions and
   examples of common use cases are included.

-  :ref:`book-databases` describes Lasso's database connection interface. Basic
   database operations as well as pointers about specific database types are
   covered.

-  :ref:`book-extending` includes tutorials and references for adding your own
   functionality using Lasso's C and Java APIs.

Explanations, method definitions, and code examples are arranged within the text
to teach you the Lasso platform step-by-step. An index is also available to help
find information about a particular language element.


.. rubric:: Conventions Used in This Guide

There are many code samples used throughout this guide. References to methods,
types, or traits and small snippets of code inlined with other text are set in a
monospace typeface, e.g. `sample_method` or ``short code snippet``. References
to variable names or to values will be in double quotes "like this".

Longer blocks of sample code will be slightly offset from the surrounding text
and will have syntax highlighting applied to them. The result produced by
running the code will be displayed using line comments. If the result fits on
one line, then a line comment in the form of ``// => Value Produced`` will be
used. If multiple lines are needed, then the first line will just have ``// =>``
while all subsequent lines will start with a line comment and space, followed by
the value for that line. For example::

   // Single-line value produced
   2 + 3
   // => 5

   // Multi-line value produced
   'Line one.' + '\n' + 'Line two.'

   // =>
   // Line one.
   // Line two.

For examples involving running commands from the command line, a shell prompt
(``$>``) will be used. Any output to standard out that is generated from the
command will be shown below the command as you would see it in your terminal.
For examples of issuing Lasso commands from the interactive interpreter, a Lasso
prompt (``>:``) will be used, and any values produced from running those
commands will be shown using the line comment convention as outlined above for
sample code blocks.


.. rubric:: Additional Resources

Here are some additional resources you may find useful:

`Lasso Reference <http://www.lassosoft.com/lassoDocs/languageReference>`_
   Reference to the built-in types, methods, and traits.

`LassoTalk <http://www.lassotalk.com/>`_
   The online Lasso community/email list is a great place to ask questions and
   get answers.

`TagSwap <http://www.lassosoft.com/tagswap>`_
   Methods, types, and traits created by members of the Lasso community to solve
   common problems.

`LassoSoft Website <http://www.lassosoft.com/>`_
   The latest information about Lasso.

`Lasso source code repository <http://source.lassosoft.com/svn/lasso/lasso9_source/trunk/>`_
   An SVN repository containing source code for a number of Lasso components.

`LassoGuide PDF <http://lassoguide.com/LassoGuide9.2.pdf>`_
   The current version of LassoGuide in PDF format.

`LassoGuide source <http://source.lassosoft.com/svn/guide/>`_
   The SVN repository containing the full LassoGuide source.

.. raw:: latex

   \endgroup
   \vfill
   \clearpage
   \thispagestyle{empty}
   \cleardoublepage
   \pagenumbering{arabic}
   \pagestyle{normal}
