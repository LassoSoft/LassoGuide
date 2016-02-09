.. http://www.lassosoft.com/Lasso-9-Server-Linux-Installation
.. highlight:: none
.. _ubuntu-installation:

*******************
Ubuntu Installation
*******************

These instructions are for installing Lasso Server on 64-bit Ubuntu 12.04 or
later.


Installation with apt
=====================

If you don't already have the :command:`add-apt-repository` program, install it
with the following command::

   $> sudo apt-get install python-software-properties

To install Lasso Server via :command:`apt`, the LassoSoft repository must be
configured on the server. Add the repository by running the following command::

   $> sudo add-apt-repository "deb http://debianrepo.lassosoft.com/ stable main"

Then run the following to install Lasso Server::

   $> sudo apt-get update
   $> sudo apt-get install lasso-instance-manager

Lasso's Java support (which includes methods for PDF manipulation) and
ImageMagick support are provided as separate packages. If you need the
functionality these packages provide, they can be installed with the following
commands::

   $> sudo apt-get install lasso-java-api
   $> sudo apt-get install lasso-imagemagick

When done, open :ref:`!http://your-server-domain.name/lasso9/instancemanager`
to load the initialization form and complete your Lasso installation.

From here on, you can read up on using the :ref:`instance-manager` and
:ref:`instance-administration` interfaces.
