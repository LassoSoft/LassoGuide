.. http://www.lassosoft.com/Lasso-Server-9-Windows-Installation-Guide
.. _windows-installation:

********************
Windows Installation
********************

These instructions are for installing Lasso 9 Server on 64-bit Windows Server
2012, Windows Server 2008 R2, Windows 8, and Windows 7. Supported web servers
are IIS 8, IIS 7, and Apache 2.2.

.. note::
   Windows Vista is not an officially supported operating system.


Before Installing
=================

Lasso Server 9.2 requires the following Microsoft updates:

-  `Microsoft .NET Framework 3.5`_ (for servers running Windows Server, use
   Server Manager to add the Application Server role, which includes .NET
   Framework 3.5.1)
-  `Microsoft .NET Framework 4`_
-  `Microsoft Visual C++ 2012 Redistributable`_ (bundled with installer)
-  Servers running IIS 7 need ISAPI enabled:

   -  For Windows Server, use the Roles Wizard to add "ISAPI Extensions" and
      "ISAPI Filters" under :menuselection:`Web Server --> Application
      Development`.
   -  For other Windows versions, open :menuselection:`Control Panel -->
      Programs and Features` and click :guilabel:`Turn Windows features on or
      off`, then under :menuselection:`Internet Information Services --> World
      Wide Web Services --> Application Development Features`, enable
      "ISAPI Extensions" and "ISAPI Filters".


Installation
============

Download and expand the correct `Lasso 9 Server for Windows`_ installer for your
OS and web server from the LassoSoft website and run the installer package.

When done, open :ref:`!http://your-server-domain.name/lasso9/instancemanager`
to load the initialization form and complete your Lasso installation.


Configuring IIS 7 or 8
======================

To configure IIS 7 or 8 manually:

-  `Open IIS Manager`_ and expand your computer name from the nodes on the left.
-  Select a web site from the nodes on the left and double-click on
   :guilabel:`Handler Mappings`.
-  Click :guilabel:`Add Script Map...` to add a new script map:

   -  Request Path: ``*.lasso``
   -  Executable: :file:`C:\\Windows\\system32\\isapi_lasso9.dll`
   -  Name: ``Lasso9Handler``

To configure access to Lasso Instance Manager and Lasso Server Admin:

-  In IIS Manager, expand your computer name from the nodes on the left.
-  Select a web site from the nodes on the left, then right-click.
-  Select :guilabel:`Add Application...` to add a new application:

   -  Alias: ``lasso9``
   -  Application Pool: select an appropriate pool (generally DefaultAppPool is
      acceptable)
   -  Physical Path:
      :file:`C:\\Program Files\\LassoSoft\\Lasso Instance Manager\\www\\\ `

-  Select the newly created application from the nodes on the left and
   double-click on :guilabel:`Handler Mappings`.
-  Click :guilabel:`Add Script Map...` to add a new script map:

   -  Request Path: ``*``
   -  Executable: :file:`C:\\Windows\\System32\\isapi_lasso9.dll`
   -  Name: ``LassoAdmin``


Configuring Apache 2.2
======================

.. note::
   Only 32-bit installers of Apache 2.2 are officially available from
   `<http://httpd.apache.org/>`_, but `unofficial 64-bit installers`_ can be
   found elsewhere online.

-  Open
   :file:`C:\\Program Files\\LassoSoft\\Lasso Instance Manager\\home\\LassoExecutables\\\ `
   and copy these files:

   -  :file:`mod_lasso9.dll` into the Apache :file:`modules\\\ ` folder
   -  :file:`mod_lasso9.conf` into the Apache :file:`conf\\\ ` folder

-  Edit the Apache :file:`httpd.conf` file and add the following line:
   ``Include conf/mod_lasso9.conf``
-  Restart Apache.
-  In a browser, open :ref:`!http://localhost/lasso9/instancemanager` to load
   the initialization form and complete your Lasso installation.


Configuring ImageMagick
=======================

-  Download and install "ImageMagick-6.7.7-7-Q16-windows-x64-dll.exe" from an
   `ImageMagick installers archive`_.
-  :ref:`Restart Lasso Instance Manager <instance-manager-starting-stopping>`.

.. only:: html

   .. important::
      Links to third-party distributions and tools are provided for your
      convenience and were accurate when this manual was written. LassoSoft
      cannot guarantee the availability or suitability of software downloaded
      from third-party web sites.


Troubleshooting
===============

Lasso Connector for IIS is not loading a page.
   -  The Application Pool for the site may be set to run 32-bit applications.
      To disable:

      #. Select the site's "Application Pool"
      #. Click :guilabel:`Advanced Settings`
      #. Set "Enable 32-bit Applications" to "False"

   -  IIS may be missing required features. To check:

      :Windows Server:
         #. Open :file:`Server Manager`
         #. Select "Roles" node
         #. Scroll to "Web Server"
         #. Click :guilabel:`Add Role Services`
         #. Expand :menuselection:`Web Server --> Common HTTP Features`
         #. Check "Default Document" and "Static Content"
         #. Continue through installation wizard

      :Windows 7 or 8:
         #. Open "Control Panel"
         #. Open :file:`Programs and Features`
         #. Click :guilabel:`Turn Windows features on or off"`
         #. Expand :menuselection:`Internet Information Services --> World Wide
            Web Services --> Common HTTP Features`
         #. Check "Default Document" and "Static Content"
         #. Click :guilabel:`OK`
         #. Continue through installation wizard

ISAPI Filters option for IIS 7 is missing.
   -  If you cannot find the ISAPI Filters option, it is most likely not
      installed. To install ISAPI Filters on IIS 7 or 8:

      :Windows Server:
         #. Open :file:`Server Manager`
         #. Select "Roles" node
         #. Scroll to "Web Server"
         #. Click :guilabel:`Add Role Services`
         #. Expand :menuselection:`Web Server --> Application Development`
         #. Check "ISAPI Extensions" and "ISAPI Filters"
         #. Continue through installation wizard

      :Windows 7 or 8:
         #. Open "Control Panel"
         #. Open :file:`Programs and Features`
         #. Click :guilabel:`Turn Windows features on or off"`
         #. Expand :menuselection:`Internet Information Services --> World Wide
            Web Services --> Application Development Features`
         #. Check "ISAPI Extensions" and "ISAPI Filters"
         #. Click :guilabel:`OK`
         #. Continue through installation wizard

Standard 500 error page is returned instead of Lasso's default error page.
   -  IIS's "HTTP Errors" feature may be enabled. To disable:

      :Windows Server:
         #. Open :file:`Server Manager`
         #. Select "Roles" node
         #. Scroll to "Web Server"
         #. Click :guilabel:`Remove Role Services`
         #. Expand :menuselection:`Web Server --> Common HTTP Features`
         #. Uncheck "HTTP Errors"
         #. Continue through installation wizard

      :Windows 7 or 8:
         #. Open "Control Panel"
         #. Open :file:`Programs and Features`
         #. Click :guilabel:`Turn Windows features on or off"`
         #. Expand :menuselection:`Internet Information Services --> World Wide
            Web Services --> Common HTTP Features`
         #. Uncheck "HTTP Errors"
         #. Click :guilabel:`OK`
         #. Continue through installation wizard

.. only:: html

   LassoTube How-Tos
   =================

   -  `Configure Apache 2 and Lasso
      <http://www.youtube.com/watch?v=f7oCiUw-OxA&list=UUVvBq5EMVi4KoME3rvNOgOA&index=2&feature=plcp>`_
   -  `Configure IIS 7 for Lasso
      <http://www.youtube.com/watch?v=oQ-6K3EHY3M&feature=relmfu>`_

.. _Microsoft .NET Framework 3.5: http://www.microsoft.com/en-us/download/details.aspx?id=22
.. _Microsoft .NET Framework 4: http://www.microsoft.com/en-us/download/details.aspx?id=17718
.. _Microsoft Visual C++ 2012 Redistributable: http://www.microsoft.com/en-us/download/details.aspx?id=30679
.. _Lasso 9 Server for Windows: http://www.lassosoft.com/Lasso-9-Server-Download#Win
.. _Open IIS Manager: http://technet.microsoft.com/en-us/library/cc770472(v=ws.10).aspx
.. _unofficial 64-bit installers: http://www.anindya.com/apache-http-server-2-4-4-and-2-2-24-x86-32-bit-and-x64-64-bit-windows-installers/
.. _ImageMagick installers archive: http://ftp.sunet.se/pub/multimedia/graphics/ImageMagick/binaries/
