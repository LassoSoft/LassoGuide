.. _ubuntu-installation:

**************************************
Lasso 9 Server for Ubuntu Installation
**************************************

Ubuntu 12.04 LTS Installation
=============================

Ubuntu 12.04 has removed two dependancies from its apt repositories. Prior to
installing Lasso 9 on 12.04 and later you must install libzip1 and libicu44.
This can be done by running the following commands::
   
   wget https://launchpad.net/ubuntu/+source/libzip/0.9.3-1/+build/1728114/+files/libzip1_0.9.3-1_amd64.deb
   wget http://launchpadlibrarian.net/91128142/libicu44_4.4.2-2ubuntu0.11.04.1_amd64.deb
   sudo dpkg -i libzip1_0.9.3-1_amd64.deb
   sudo dpkg -i libicu44_4.4.2-2ubuntu0.11.04.1_amd64.deb

If you don't already have the ``add-apt-repository`` program, install it with
the following command::

   sudo apt-get install python-software-properties

To install Lasso 9 Server via apt, the LassoSoft repository must be configured
on the server. Add the repository by running the following command::

   sudo add-apt-repository "deb http://debianrepo.lassosoft.com/ stable main"

Then run the following to install Lasso 9 Server::

   sudo apt-get update
   sudo apt-get install lasso-instance-manager

Lasso's Java support (which includes methods for PDF manipulation) and
ImageMagick support are provided as separate packages. If you need the
functionality these pacakges provide, they can be installed with the following
commands::

   sudo apt-get install lasso-java-api
   sudo apt-get install lasso-imagemagick

When done, open http://server-domain.name/lasso9/instancemanager to complete the
installation.

From here, you can read up on :ref:`using the Instance Manager
<instance-manager>` and :ref:`Instance Administration<instance-administration>`.