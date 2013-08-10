.. Lasso Guide documentation master file, created by
   sphinx-quickstart on Tue Jul 31 01:26:58 2012.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

.. Eventually I'd like to replace this front page with something nicer-looking
   that uses the full page width.

*****************************
 Welcome to **Lasso**\ Guide
*****************************

Lasso is a powerful programming language used to drive millions of web pages
from servers around the world. It has an easy-to-master syntax and allows fast,
flexible development and scripting. Lasso can be used in many ways, and as a
language provides a virtually infinite set of shortcuts for completing
development goals.

.. only:: html

   What follows is a living set of documentation for the Lasso 9 programming
   language. As this documentation will change or be improved over time, please
   regularly review during your development and feel free to ask questions or
   make suggestions for improvement. Send and and all requests or suggestions to
   docs@lassosoft.com; we will review and answer as soon as possible.

.. only:: latex

   This document was created on |today| for |version|. The most up-to-date
   version of this documentation containing all fixes can be found at
   `<http://lassoguide.com>`_

.. only:: html

   .. toctree::
      :maxdepth: 1

      server/index_server
      language/index_language
      operations/index_operations
      databases/index_databases
      api/index_api
      getstart/index_getstart


How to Use this Guide
=====================

This guide has many parts and is inteneded to cover all aspects of the Lasso
programming language. Due to its comprehensive nature, you probably don't want
to read it all the way through. The following is one suggestion for how to get
the most out of this set of documentation:

-  Read most everything in the introduction, but read just the installation
   instructions for the one OS you are using. Also, for the most part you can
   skip over the chapter on "Configuration and Administration" if you are just
   getting started and come back to it when you need it.

-  After reading through "A Taste of Lasso", you are probably ready to start
   cutting your teeth on Lasso, and while you are doing that (or before), read
   through the entire Lasso Language Guide to become familiar with the basic
   features and syntax.

-  Read through the chapter titles in all the other sections to familiarize
   yourself with the contents of this documentation. When you find yourself
   needing to know more about some aspect or feature of Lasso then read through
   the chpater on it.


Conventions Used in this Guide
==============================

There are many code samples used throughout this book. When referencing a method
or type or small snippet of code inline with other text, that code will appear
``looking like this``. References to variable names or to values will be in
double quotes "like this".

Longer code blocks will be offset from text a bit and will have syntax
highlighting applied to them. The result produced by running the code will be
displayed using line comments. If the result fits on one line, then a line
comment in the form of ``// => Value Produced`` will be used. If multiple lines
are needed then the first line will just have ``// =>`` while all subsequent
lines will start with a line comment followed by a space and then the value for
that line. For example::

   // One line value produced
   2 + 3
   // => 5

   // Multi-line value produced
   "Line one." + "\n" + "Line two."
   // =>
   // Line one.
   // Line two.

For examples involving running commands from the command-line, a prompt of "$> "
will be used. Any output to standard out that is generated from the command will
be shown below the command as you would see it in your terminal. For examples of
issuing Lasso commands from the interactive interpreter, a prompt of ">: " will
be used and any values produced from running those commands will be shown using
the line comment convention as outlined above for code blocks.


Additional Resources
====================

Here are some additional resources you may find handy:

`Lasso Reference <http://www.lassosoft.com/lassoDocs/languageReference>`_
   Reference to the built-in types, methods, and traits.

`LassoTalk <http://www.lassosoft.com/LassoTalk/>`_
   The online community / email list. A great place to ask questions and get
   answers.

`Tag Swap <http://www.lassosoft.com/tagswap>`_
   Methods, types, and traits created by members of the Lasso community to solve
   common problems.

`LassoSoft Website <http://www.lassosoft.com>`_
   The latest information about Lasso.


.. only:: html

   Appendices
   ==========

   .. glossary
   .. credits
   .. copyright
   .. license

   * :ref:`genindex`
   * :ref:`glossary`
   * :ref:`search`
