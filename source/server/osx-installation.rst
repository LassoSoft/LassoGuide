.. http://www.lassosoft.com/Lasso-9-Server-Mac-Installation
.. _osx-installation:

*****************
OS X Installation
*****************

These instructions are for installing Lasso Server on OS X. An Intel-based Mac
running OS X 10.7 or later is required.


OS X Prerequisites
==================

-  Lasso's :ref:`PDF functions <pdf>` require a Java 8 runtime. The latest
   version of Oracle's Java Runtime Environment can be downloaded from the
   `Java support site`_.

-  OS X 10.11 also requires `Java 6 from Apple`_ due to an outstanding bug in
   Oracle's Java distribution.


Installation
============

#. Download and expand the `Lasso Server for OS X`_ installer from the LassoSoft
   website.

#. Run the installer to perform a standard installation, which will install
   Lasso Server and start or restart the system's Apache. By default the
   following files and folders will be installed:

   :Apache config:
      -  :file:`/etc/apache2/other/mod_lasso9.conf` (OS X 10.7 and later)
      -  :file:`/etc/apache2/sites/mod_lasso9.conf` (OS X Server 10.7)
      -  :file:`/Library/Server/Web/Config/apache2/sites/mod_lasso9.conf`
         (OS X Server 10.8 and later)
   :Apache plugin:
      -  :file:`/usr/libexec/apache2/mod_lasso9-2.2.so` (OS X 10.7 to 10.9)
      -  :file:`/usr/local/libexec/apache2/mod_lasso9-2.4.so`
         (OS X 10.10 and later)
   :shared library:
      -  :file:`/Library/Frameworks/Lasso9.framework`
   :launchd item:
      -  :file:`/Library/LaunchDaemons/com.lassosoft.lassoinstancemanager.plist`
   :binaries:
      -  :file:`/etc/paths.d/lasso`
      -  :file:`/usr/local/lasso/lasso9`
      -  :file:`/usr/local/lasso/lassoc`
      -  :file:`/usr/local/lasso/lassoim`
      -  :file:`/usr/local/lasso/lassoserver`
      -  :file:`/usr/local/lasso/lassospitfire`
   :user data:
      -  :file:`/var/lasso`

#. When the installer has finished, click on the link on the web page that
   appears to load the initialization form (found on your own machine at
   :ref:`!http://localhost:8090/lasso9/lux`) and complete your Lasso
   installation.

From here on, you can read up on using the :ref:`instance-manager` and
:ref:`instance-administration` interfaces.

.. note::
   On OS X Server, verify that the Web or Websites service is running in Server
   Preferences or Server.app.

.. important::
   If you upgrade your OS X installation or install OS X Server after installing
   Lasso Server, use the installer to reinstall the Apache component to place
   its files in the correct locations.

.. _Java support site: http://www.java.com/
.. _Java 6 from Apple: https://support.apple.com/kb/dl1572
.. _Lasso Server for OS X: http://www.lassosoft.com/Lasso-9-Server-Download#Mac
