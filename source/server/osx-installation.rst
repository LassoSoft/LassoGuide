.. http://www.lassosoft.com/Lasso-9-Server-Mac-Installation
.. _osx-installation:

*****************
OS X Installation
*****************

These instructions are for installing Lasso Server on OS X. An Intel-based Mac
running OS X 10.5 or later is required.


OS X Prerequisites
==================

-  Lasso's :ref:`PDF functions <pdf>` require a Java runtime, which is not
   included with OS X 10.7 and later. The latest version of Apple's "Java for OS
   X" can be downloaded from the `Apple support site`_.

-  Lasso's :ref:`image functions <images-media>` require X11, which is not
   included with OS X 10.8 and later. For those systems, install `XQuartz`_
   instead.


Installation
============

#. Download and expand the `Lasso Server for OS X`_ installer from the LassoSoft
   website.

#. Run the installer to perform a standard installation, which will install
   Lasso Server and start or restart the system's Apache. By default the
   following files and folders will be installed:

   :Apache config:
      -  :file:`/etc/apache2/other/mod_lasso9.10.5.conf` (OS X 10.5)
      -  :file:`/etc/apache2/sites/mod_lasso9.10.5.conf` (OS X Server 10.5)
      -  :file:`/etc/apache2/other/mod_lasso9.conf` (OS X 10.6 and later)
      -  :file:`/etc/apache2/sites/mod_lasso9.conf`
         (OS X Server 10.6 and Server 10.7)
      -  :file:`/Library/Server/Web/Config/apache2/sites/mod_lasso9.conf`
         (OS X Server 10.8 and later)
   :Apache plugin:
      -  :file:`/usr/libexec/apache2/mod_lasso9.10.5.so` (OS X 10.5)
      -  :file:`/usr/libexec/apache2/mod_lasso9.so` (OS X 10.6 and later)
   :shared library:
      -  :file:`/Library/Frameworks/Lasso9.framework`
   :launchd item:
      -  :file:`/Library/LaunchDaemons/com.lassosoft.lassoinstancemanager.plist`
   :binaries:
      -  :file:`/usr/bin/lasso9`
      -  :file:`/usr/bin/lassoc`
      -  :file:`/usr/sbin/lassoim`
      -  :file:`/usr/sbin/lassoserver`
   :user data:
      -  :file:`/var/lasso`

#. When the installer has finished, click on the link on the web page that
   appears in order to load the initialization form (found on your own machine
   at :ref:`!http://localhost/lasso9/instancemanager`) and complete your Lasso
   installation.

From here on, you can read up on using the :ref:`instance-manager` and
:ref:`instance-administration` interfaces.

.. note::
   On OS X Server, verify that the Web or Websites service is running in Server
   Preferences or Server.app.

.. important::
   If you upgrade your OS X installation or install OS X Server after installing
   Lasso Server, you will need to either manually move the Apache conf file and
   plugin for Lasso to continue running, or simply reinstall Lasso to place the
   files in the correct locations.

.. _Apple support site: https://support.apple.com/kb/DL1572
.. _XQuartz: https://www.xquartz.org
.. _Lasso Server for OS X: http://www.lassosoft.com/Lasso-9-Server-Download#Mac
