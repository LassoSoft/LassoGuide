.. http://www.lassosoft.com/Lasso-9-Server-Linux-Installation
.. highlight:: none
.. _ubuntu-installation:

*******************
Ubuntu Installation
*******************

These instructions are for installing Lasso Server on 64-bit Ubuntu 14.


Installation with apt
=====================

If you don't already have the :command:`add-apt-repository` program, install it
with the following command::

   $> sudo apt-get install python-software-properties

Import the LassoSoft public key::

   $> sudo apt-key adv --fetch-keys http://debianrepo.lassosoft.com/lassosoft-public.gpg.key

To install Lasso Server via :command:`apt`, the LassoSoft apt repository must be
configured on the server. Add the repository by running the following command::

   $> sudo add-apt-repository "deb [arch=amd64] http://debianrepo.lassosoft.com/ stable main"

Then run the following to install Lasso Server::

   $> sudo apt-get update
   $> sudo apt-get install lasso-instance-manager

Lasso's Java support (which includes methods for PDF manipulation) and
ImageMagick support are provided as separate packages. If you need the
functionality these packages provide, they can be installed with the following
commands::

   $> sudo apt-get install lasso-java-api
   $> sudo apt-get install lasso-imagemagick

When done, open :ref:`!http://your-server-domain.name:8090/lasso9/lux` to load
the initialization form and complete your Lasso installation. From here on, you
can read up on using the :ref:`instance-manager` and
:ref:`instance-administration` interfaces.


Package Installation
====================

To install Lasso directly from the Debian packages, download the latest releases
from the `repository archive`_, then run these commands (ignore errors when
running :command:`dpkg`)::

   $> sudo apt-get update
   $> sudo apt-get install apache2
   $> sudo dpkg -i lasso-instance-manager_9.3*.deb lasso-imagemagick_9.3*.deb lasso-java-api_9.3*.deb
   $> sudo apt-get install -f

.. _repository archive: http://debianrepo.lassosoft.com/9.3/
