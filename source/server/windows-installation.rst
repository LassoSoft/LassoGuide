.. http://www.lassosoft.com/Lasso-Server-9-Windows-Installation-Guide
.. _windows-installation:

********************
Windows Installation
********************

These instructions are for installing Lasso Server on 64-bit Windows Server
2012, Windows Server 2008 R2, Windows 8, and Windows 7. Supported web servers
are IIS 7, IIS 8, and Apache 2.2.


Windows Prerequisites
=====================

Lasso Server requires the following Microsoft updates:

-  `Microsoft Visual C++ 2012 Redistributable`_ (auto-installed if required)
-  Servers running IIS 7 or 8 need ISAPI enabled:

   -  For Windows Server, use the Roles Wizard to add "ISAPI Extensions" and
      "ISAPI Filters" under :menuselection:`Web Server --> Application
      Development`.
   -  For other Windows versions, open :menuselection:`Control Panel -->
      Programs and Features` and click :guilabel:`Turn Windows features on or
      off`, then under :menuselection:`Internet Information Services --> World
      Wide Web Services --> Application Development Features`, enable
      "ISAPI Extensions" and "ISAPI Filters".

These installs are optional, but recommended:

-  Lasso's :ref:`PDF functions <pdf>` require a Java runtime. The latest version
   of Oracle's Java Runtime Environment can be downloaded from the `Java support
   site`_.

-  Lasso's :ref:`image functions <images-media>` require ImageMagick. Download
   and install "ImageMagick-6.7.7-7-Q16-windows-x64-dll.exe" or later from an
   `ImageMagick installers archive`_.

-  Running Lasso under Apache requires a 64-bit installation of Apache 2.2. Only
   32-bit installers of Apache 2.2 are officially available from
   `<http://httpd.apache.org/>`_, but `unofficial 64-bit installers`_ can be
   found elsewhere online.


If either is installed after Lasso, restart Lasso Instance Manager by opening
the built-in Services application, selecting the "Lasso Instance Manager"
service, and clicking the "Restart Service" icon.

.. only:: html

   .. important::
      Links to third-party distributions and tools are provided for your
      convenience and were accurate when this guide was written. LassoSoft
      cannot guarantee the availability or suitability of software downloaded
      from third-party web sites.


Installation
============

#. Download the `Lasso Server for Windows`_ installer for your preferred web
   server from the LassoSoft website and run the installer package. (Their
   contents are identical, but only the IIS installer configures IIS for you
   automatically.) By default the following files and folders will be installed:

   :Lasso folder:
      :file:`C:\\Program Files\\LassoSoft\\Lasso Instance Manager\\\ `
   :IIS plugin:
      :file:`C:\\Windows\\System32\\isapi_lasso9.dll`

#. When the installer has finished and your web server has been configured, open
   :ref:`!http://your-server-domain.name:8090/lasso9/lux` to load the
   initialization form and complete your Lasso installation. From here on, you
   can read up on using the :ref:`instance-manager` and
   :ref:`instance-administration` interfaces.


Configuring IIS 7 or 8
======================

These steps will replicate the configuration commands run by the IIS installer.

To add Lasso Connector for IIS to the list of allowed ISAPI extensions:

-  `Open IIS Manager`_ and select your computer name from the nodes on the left.
-  In the main panel, double-click on :guilabel:`ISAPI and CGI Restrictions`.
-  Click :guilabel:`Add...` to add a new entry:

   -  ISAPI or CGI path: :file:`C:\\Windows\\System32\\isapi_lasso9.dll`
   -  Description: ``Lasso9``
   -  Check :guilabel:`Allow extension path to execute`

-  Back in the main panel, double-click on :guilabel:`ISAPI Filters`.
-  Click :guilabel:`Add...` to add a new entry:

   -  Filter name: ``isapi_lasso9.dll``
   -  Executable: :file:`C:\\Windows\\System32\\isapi_lasso9.dll`

To pass requests for "\*.lasso" files to Lasso Server:

-  `Open IIS Manager`_ and select your computer name from the nodes on the left,
   or a site within it.
-  In the main panel, double-click on :guilabel:`Handler Mappings`.
-  Click :guilabel:`Add Script Map...` to add a new script map:

   -  Request path: ``*.lasso``
   -  Executable: :file:`C:\\Windows\\System32\\isapi_lasso9.dll`
   -  Name: ``Lasso9Handler``
   -  Request Restrictions...: under :guilabel:`Mapping`, uncheck "Invoke
      handler only if request is mapped" (leave other settings at "All verbs"
      and "Script")

To configure access to Lasso Instance Manager and Lasso Server Admin:

-  `Open IIS Manager`_ and expand your computer name from the nodes on the left.
-  Right-click a web site under your computer name, e.g. "Default Web Site".
-  Select :guilabel:`Add Application...` to add a new application:

   -  Alias: ``lasso9``
   -  Application pool: select an appropriate pool (generally DefaultAppPool is
      acceptable)
   -  Physical path:
      :file:`C:\\Program Files\\LassoSoft\\Lasso Instance Manager\\www\\\ `

-  Select the newly created application from the nodes on the left and
   double-click on :guilabel:`Handler Mappings`.
-  Click :guilabel:`Add Script Map...` to add a new script map:

   -  Request path: ``*``
   -  Executable: :file:`C:\\Windows\\System32\\isapi_lasso9.dll`
   -  Name: ``LassoAdmin``
   -  Request Restrictions...: under :guilabel:`Mapping`, uncheck "Invoke
      handler only if request is mapped" (leave other settings at "All verbs"
      and "Script")

Restart IIS when finished to apply the new configuration.


Configuring Apache 2.2
======================

These steps must be run manually for Apache to serve Lasso pages.

-  Open
   :file:`C:\\Program Files\\LassoSoft\\Lasso Instance Manager\\home\\LassoExecutables\\\ `
   and copy these files:

   -  :file:`mod_lasso9.dll` into the Apache :file:`modules\\\ ` folder
   -  :file:`mod_lasso9.conf` into the Apache :file:`conf\\\ ` folder

-  In the :file:`conf\\\ ` folder, open the Apache :file:`httpd.conf` file for
   editing and add the following line: ``Include conf/mod_lasso9.conf``
-  Restart Apache.
-  In a browser, open :ref:`!http://localhost/lasso9/instancemanager` to load
   the initialization form and complete your Lasso installation.


Troubleshooting
===============

.. rubric:: ISAPI and CGI Restrictions or ISAPI Filters options for IIS are
   missing.

-  If you cannot find either ISAPI option, it is most likely not installed. To
   install the ISAPI options on IIS 7 or 8:

   :Windows Server:
      #. Open :file:`Server Manager`
      #. Navigate to the list of currently installed Web Server roles
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

.. rubric:: IIS gives the error ``Handler "Lasso9Handler" has a bad module
   "IsapiModule" in its module list`` when loading "\*.lasso" files.

-  IIS's ISAPI options are not installed, or were installed after Lasso Server.
   Follow the steps above to ensure ISAPI is installed and manually add Lasso
   Connector for IIS to the list of allowed ISAPI extensions.

.. rubric:: Lasso pages are not loading.

-  The Application Pool for the site may be set to run 32-bit applications. To
   disable:

   #. Open :file:`IIS Manager`
   #. Select the site's "Application Pool"
   #. Click :guilabel:`Advanced Settings`
   #. Set "Enable 32-bit Applications" to "False"

-  IIS may be missing required features. To check:

   :Windows Server:
      #. Open :file:`Server Manager`
      #. Navigate to the list of currently installed Web Server roles
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

.. rubric:: Standard 404 error page is returned instead of Lasso's default not
   found page.

-  IIS's handler for "\*.lasso" files may have a request restriction set. To
   disable:

   #. Open :file:`IIS Manager`
   #. Select your computer name from the nodes on the left or a site within
      it, depending where the handler was first defined
   #. In the main panel, double-click on :guilabel:`Handler Mappings`
   #. Edit the script map for "\*.lasso" files
   #. Click :guilabel:`Request Restrictions...`
   #. Under :guilabel:`Mapping`, uncheck "Invoke handler only if request is
      mapped"
   #. Click :guilabel:`OK` twice, then :guilabel:`Yes` to apply the change

.. rubric:: Standard 500 error page is returned instead of Lasso's default error
   page.

-  IIS's "HTTP Errors" feature may be enabled. To disable:

   :Windows Server:
      #. Open :file:`Server Manager`
      #. Navigate to the list of currently installed Web Server roles
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

.. _Microsoft Visual C++ 2012 Redistributable: http://www.microsoft.com/en-us/download/details.aspx?id=30679
.. _Java support site: http://www.java.com/
.. _ImageMagick installers archive: http://ftp.icm.edu.pl/packages/ImageMagick/binaries/
.. _unofficial 64-bit installers: http://www.anindya.com/apache-http-server-2-4-4-and-2-2-24-x86-32-bit-and-x64-64-bit-windows-installers/
.. _Lasso Server for Windows: http://www.lassosoft.com/Lasso-9-Server-Download#Win
.. _Open IIS Manager: https://technet.microsoft.com/en-us/library/cc770472(v=ws.10).aspx
