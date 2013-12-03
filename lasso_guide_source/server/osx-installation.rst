.. http://www.lassosoft.com/Lasso-9-Server-Mac-Installation
.. _osx-installation:

*****************
OS X Installation
*****************

These instructions are for installing Lasso 9 Server on OS X. An Intel-based Mac
running OS X 10.5 or later is required.


Before Installing
=================

-  Lasso requires a Java runtime, which is not included with OS X 10.7 and
   later. The latest version of Apple's "Java for OS X" can be downloaded from
   the `Apple support site`_ or installed automatically by the Lasso installer.

-  Lasso requires X11, which is not included with OS X 10.8 and later. For those
   systems, install `XQuartz`_ instead.


Installation
============

#. Download and expand `Lasso 9 Server for OS X`_ from the LassoSoft website.

#. Run the installer to perform a standard installation, which will install
   Lasso 9 and start or restart the system's Apache. By default the following
   files and folders will be installed:

   -  Apache conf file

      -  :file:`/etc/apache2/other/mod_lasso9.10.5.conf` (OS X 10.5)
      -  :file:`/etc/apache2/sites/mod_lasso9.10.5.conf` (OS X Server 10.5)
      -  :file:`/etc/apache2/other/mod_lasso9.conf` (OS X 10.6 and later)
      -  :file:`/etc/apache2/sites/mod_lasso9.conf`
         (OS X Server 10.6 and Server 10.7)
      -  :file:`/Library/Server/Web/Config/apache2/sites/mod_lasso9.conf`
         (OS X Server 10.8 and later)

   -  Apache plugin

      -  :file:`/usr/libexec/apache2/mod_lasso9.10.5.so` (OS X 10.5)
      -  :file:`/usr/libexec/apache2/mod_lasso9.so` (OS X 10.6 and later)
      -  :file:`/Applications/Server.app/Contents/ServerRoot/usr/libexec/apache2/mod_lasso9.so`
         (OS X Server 10.9 and later)

   -  :file:`/Library/Frameworks/Lasso9.framework`
   -  :file:`/Library/LaunchDaemons/com.lassosoft.lassoinstancemanager.plist`
   -  :file:`/usr/bin/lasso9`
   -  :file:`/usr/bin/lassoc`
   -  :file:`/usr/sbin/lassoim`
   -  :file:`/usr/sbin/lassoserver`
   -  :file:`/var/lasso`

#. When the installer has finished, click on the link on the web page that
   appears in order to load the initialization form for Lasso Instance Manager
   (found on your own machine at
   :ref:`!http://localhost/lasso9/instancemanager`).

#. Use the form to set an administrator username and password for your Lasso
   installation and default instance.

From here on, you can read up on using the :ref:`instance-manager` and
:ref:`instance-administration`.

.. note::
   On OS X Server, ensure that the Web or Websites service is running in Server
   Preferences or Server.app.

.. important::
   If you upgrade your OS X installation or install OS X Server after installing
   Lasso 9 Server, you will need to either manually move the Apache conf file
   and plugin for Lasso to continue running, or simply reinstall Lasso to place
   the files in the correct locations.

.. _Apple support site: http://support.apple.com/downloads
.. _XQuartz: http://xquartz.macosforge.org/
.. _Lasso 9 Server for OS X: http://www.lassosoft.com/Lasso-9-Server-Download#Mac
