.. _osx-installation:

*****************
OS X Installation
*****************

These instructions detail how to install Lasso 9 Server using the standard
installer package. An Intel-based Mac running OS X 10.5 or later is required.

.. note::
   If you upgrade to OS X Server after installing Lasso 9 Server, you will need
   to manually move the Lasso conf file from "/etc/apache2/other" to
   "/etc/apache2/sites" for Lasso to continue running.

#. `Download Lasso 9 Server for OS X
   <http://www.lassosoft.com/Lasso-9-Server-Download>`_ from the LassoSoft
   website.
#. Run the installer to perform a standard installation, which will install
   Lasso 9 and start or restart the system's Apache. By default the following
   files will be installed:

   -  /etc/apache2/other/mod\_lasso9.conf or
      /etc/apache2/other/mod\_lasso9.10.5.conf (OS X 10.5) (On OS X Server, the
      file will be in /etc/apache2/sites) 
   -  /usr/libexec/apache2/mod\_lasso9.so or
      /usr/libexec/apache2/mod\_lasso9.10.5.so
   -  /Library/Frameworks/Lasso9.framework
   -  /Library/LaunchDaemons/com.lassosoft.lassoinstancemanager.plist
   -  /var/lasso
   -  /usr/bin/lasso9
   -  /usr/bin/lassoc
   -  /usr/sbin/lassoim
   -  /usr/sbin/lassoserver

#. When the installer has finished, click on the link that appears to start and
   go to the Lasso Instance Manager (found at "/lasso9/instancemanager/" on your
   machine).
#. Use the web form to set an administrator username and password for your Lasso
   installation.

From here on, you can read up on :ref:`using the Instance Manager
<instance-manager>` and :ref:`Instance Administration<instance-administration>`.