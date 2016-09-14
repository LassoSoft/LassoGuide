.. http://www.lassosoft.com/Lasso-9-Server-Linux-Installation
.. highlight:: none
.. _ubuntu-installation:

*******************
Ubuntu Installation
*******************

These instructions are for installing Lasso Server on 32-bit/64-bit Ubuntu 12.

.. only:: html

   .. note::
      For Ubuntu 14, you'll first need to manually download and install
      `libicu48 for i386`_ or `libicu48 for amd64`_, and after installing Lasso,
      download and install a newer module :download:`compiled for Apache 2.4
      <../_downloads/u14_ap24_mod_lasso9.zip>` to the original's location at
      :file:`/usr/lib/apache2/modules/mod_lasso9.so`.


Installation with apt
=====================

To install Lasso Server via :command:`apt`, the LassoSoft repository must be
configured on the server. Add the repository by appending this to
:file:`/etc/apt/sources.list`::

   deb http://debianrepo.lassosoft.com/ legacy main

Import the LassoSoft public key::

   $> curl http://debianrepo.lassosoft.com/lassosoft-public.gpg.key | sudo apt-key add -

Then run the following to install Lasso Server::

   $> sudo apt-get update
   $> sudo apt-get install lasso-instance-manager

Lasso's Java support (which includes methods for PDF manipulation) and
ImageMagick support are provided as separate packages. If you need the
functionality these packages provide, they can be installed with the following
commands::

   $> sudo apt-get install lasso-java-api
   $> sudo apt-get install lasso-imagemagick

When done, open :ref:`!http://your-server-domain.name/lasso9/instancemanager` to
load the initialization form and complete your Lasso installation. From here on,
you can read up on using the :ref:`instance-manager` and
:ref:`instance-administration` interfaces.


Package Installation
====================

To install Lasso directly from the Debian packages, download the latest releases
from the `repository archive`_, then run these commands (ignore errors when
running :command:`dpkg`)::

   $> sudo apt-get update
   $> sudo apt-get install apache2
   $> sudo dpkg -i lasso-instance-manager_9.2*.deb lasso-imagemagick_9.2*.deb lasso-java-api_9.2*.deb
   $> sudo apt-get install -f

.. _libicu48 for i386: https://launchpad.net/ubuntu/trusty/i386/libicu48/4.8.1.1-13+nmu1ubuntu1
.. _libicu48 for amd64: https://launchpad.net/ubuntu/trusty/amd64/libicu48/4.8.1.1-13+nmu1ubuntu1
.. _repository archive: http://debianrepo.lassosoft.com/9.2/
