.. _server-overview:

***********************
Lasso Platform Overview
***********************

Welcome to Lasso Server, a powerful and comprehensive tool for building and
hosting data-driven web applications. This chapter introduces important concepts
and information you should know before starting to use the Lasso Platform or
Lasso Server.

Lasso Server (and Lasso Developer) is server-side software that runs along with
any FastCGI capable web server. It adds a suite of dynamic functionality and
database connectivity to your web site. This functionality empowers you to build
and serve just about any dynamic web application that you need with maximum
productivity and ease.

.. only:: html

    Lasso Server works by receiving requests from the web server and routing
    those requests to specific server-side resources. Generally, these local
    resources are files written in the Lasso language. Lasso can be easily
    embedded in templates with HTML, XML or other data types. Lasso Server
    manages processing and executing these files and responding to the client
    with the resulting data. The details of programming in the Lasso language
    are covered in the :ref:`Lasso Language Guide<lasso-language-guide-index>`
    and :ref:`Lasso Operations Guide <lasso-operations-guide-index>` included
    with this product.

.. only:: latex

    Lasso Server works by receiving requests from the web server and routing
    those requests to specific server-side resources. Generally, these local
    resources are files written in the Lasso language. Lasso can be easily
    embedded in templates with HTML, XML or other data types. Lasso Server
    manages processing and executing these files and responding to the client
    with the resulting data. The details of programming in the Lasso language
    are covered in this book starting with Part II, :ref:`the Lasso Language
    Guide<lasso-language-guide-index>`.

Lasso Runtime
=============

The Lasso runtime is a language platform designed from the ground up with the
single purpose of hosting online applications. It was engineered with a focus on
scalability and performance. Lasso's threading model is integrated with its
transparent event driven IO sub-system to make efficient use of hardware with
multiple CPUs and to ensure that network requests are served promptly under
heavy load.

The Lasso runtime system manages the dynamic compilation of Lasso language code
down to native machine code with integrated caching schemes and automatic
optimization of the most frequently used methods and object types. It also
supports a flexible array of options for ahead of time code compilation into
dynamically loaded libraries as well as stand-alone executables for Mac OS X and
Linux platforms.

Though the Lasso runtime can operate in the role of a quick command-line
utility, it is designed with features to support the needs of a "stay running"
application process. Internally, such an application consists of a set of
sub-processes, or threads, each waiting to receive messages and sleeping until
such messages arrive. Each thread maintains its own set of variables and a
thread can not directly access the variables of another thread.

Lasso Language
==============

This version of the Lasso language builds upon many years of success with
providing a versatile and full featured programming language. Lasso is a
dynamically-typed, object-oriented language with close ties to its database
abstraction layer. The language integrates closely to the Lasso runtime to give
access to the lower level operating system in a uniform and performance-minded
manner. It improves upon this by already including many of the most useful 3rd
party libraries, data sources, technologies and protocols.

Lasso's type system combines the dynamic nature of scripting languages with
some of the safety and features normally only available in statically typed
languages. Types can be extended through a "traits" system, promoting code
reuse, and methods are open to multiple-dispatch which uses type annotations to
provide pattern matching over method calls.

New types and methods can be added at runtime, which means that a running system
is not required to be brought down for most changes. This is helpful not only
during development, but also while a system is in service and urgent, well
tested patches need to be applied.

Object types and methods can be compiled ahead of time using the Lasso compiler
(lassoc). The result of this compilation is a dynamic library which can be
loaded automatically on-demand the first time the type or method is required.
This helps keep unused data out of memory, improves startup time, and lets an
application be built and deployed in a modular manner.

Lasso Server
============

Lasso Server is a suite of tools and methodologies for developing, serving, and
administering data-driven web sites written in the Lasso language. Lasso Server
operates with any FastCGI supporting web server, such as Apache, IIS, lighttpd,
and nginx. A full compliment of methods and objects are included for accessing
web server parameters and variables as well as for encoding and decoding data
and for responding to requests.

Lasso Server provides an object model for programmatically building response
documents in addition to a simple template mode for creating or customizing
HTML, XML, PDF or any other sort of data on the fly. This system is designed to
make it easy to separate logic from presentation.

Lasso Server provides easy to use, yet powerful control over content type and
character encoding. Combined with the Lasso language's highly integrated support
for Unicode strings, Lasso Server can readily serve content for any language
using just a single string object and API.

Also provided is built-in support for logging, bulk email sending, users and
groups security, sessions, and more — including integration with many 3rd party
libraries much as curl, OpenSSL, and SQLite. Lasso Server brings a rich set of
tools together into one package.

The Lasso Server Admin application is included with Lasso Server. This
application provides administrative access to a running system. It gives access
to database configuration, users and groups, sessions, email queues, error logs
and more. Lasso Server Admin provides a unified access point for the server
administrator to monitor and configure the operations of the server.

Lasso Developer
===============

Lasso Developer is a free-of-charge, single-user edition of Lasso Server that
can be used by a single developer to create and test interactive Web sites on
their own machine. Lasso Developer has a client IP addresses limitation and per
minute transaction limit. Lasso Developer is designed for authoring and demoing
web sites and is the perfect way for getting started with Lasso Server.

Any installation of Lasso Server will default to Lasso Developer functionality
when run without a valid serial number.