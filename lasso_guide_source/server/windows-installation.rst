.. _windows-installation:

********************
Windows Installation
********************

Supported Platforms
===================

Lasso Server 9 has been tested on 64 bit Windows Server 2012, Windows Server
2008 R2, Windows 8 and Windows 7. Supported web servers are IIS 7, IIS 8 and
Apache 2.2.

.. note::
   Windows Vista is not an officially-supported operating system.

Before Installing
=================

Lasso Server 9.2 requires the following Microsoft updates:

-  `Microsoft .NET Framework 3.5
   <http://www.microsoft.com/en-us/download/details.aspx?id=25150>`_
-  `Microsoft .NET Framework 4
   <http://www.microsoft.com/en-us/download/details.aspx?id=17718>`_
-  `Microsoft Visual C++ 2012 Redistributable Package (x64)
   <http://www.microsoft.com/en-us/download/details.aspx?id=30679>`_ (bundled
   with installer)
-  Servers running IIS 7 need ISAPI enabled:

   -  For Windows Server, use the Roles Wizard to add 'ISAPI Extensions' and
      'ISAPI Filters' under Web Server > Application Development.
   -  For other Windows versions, open Control Panel > Programs and Features
      and click 'Turn Windows features on or off', then under 'Internet
      Information Services > World Wide Web Services > Application Development
      Features', enable 'ISAPI Extensions' and 'ISAPI Filters'.

Installation
============

Download the correct Lasso 9 Server installer for your OS and web server
`from the LassoSoft website
<http://www.lassosoft.com/Lasso-9-Server-Download>`_
and run the installer package.

Configuring IIS 7/8
===================

To configure IIS 7 or 8 manually :

-  Open the IIS Manager.
-  Select your computer name from the nodes on the left.
-  Select a web site from the nodes on the left.
-  In the main window, scroll down to and select 'Handler Mappings'.
-  Select 'Add Script Map'.

   -  In the 'Add Script Map' dialog box, enter these values:
   -  Request Path: \*.lasso
   -  Executable: C:\Windows\system32\isapi_lasso9.dll
   -  Name: Lasso9Handler

To configure access to the InstanceManger and Administration:

-  Open the IIS Manager
-  Select your computer name from the nodes on the left.
-  Select a web site from nodes on the left. (Right-click)
-  Select Add Application...

   -  Alias: lasso9
   -  Application Pool: Select appropriate pool (Generally DefaultAppPool is
      acceptable)
   -  Physical Path: C:\Program Files\LassoSoft\Lasso Instance Manager\www\

-  Select newly created application > Handler Mapping > Add Script Map

   -  Request Path: *
   -  Executable: C:\Windows\System32\isapi_lasso9.dll
   -  Name: LassoAdmin


Configuring Apache 2.2
======================

-  Copy the file
   C:\Program Files\LassoSoft\Lasso Instance Manager\home\LassoExecutables\mod_lasso9.dll
   into the Apache modules\ folder.
-  Copy the file
   C:\Program Files\LassoSoft\Lasso Instance Manager\home\LassoExecutables\mod_lasso9.conf
   into the Apache conf\ folder.
-  Edit the Apache httpd.conf file. Add the following line: `Include
   conf/mod_lasso9.conf`
-  Restart Apache.
-  In a browser, open the configuration page at
   http://localhost/lasso9/instancemanager.


Configuring ImageMagick
=======================

-  Navigate to the `ImageMagick downloads page
   <http://www.imagemagick.org/script/binary-releases.php?ImageMagick=8deuqrqm7sphej4ctpomkmbkg4#windows>`_.
-  Download and install ImageMagick-6.7.7-7-Q16-windows-x64-dll.exe.
- Restart Lasso 9 Server

.. note::
   Older version of ImageMagick can be `downloaded here
   <http://image_magick.veidrodis.com:8003/image_magick/binaries/>`_. However,
   downloads from this site are at your own risk. LassoSoft Inc can not
   guarantee their contents nor their continued availability.


Troubleshooting
===============

Lasso Connector for IIS is not loading a page.
   The Application Pool for the site may be set to run 32-bit applications. Edit
   the Application Pool for the site:

   -  Select Application Pool
   -  Click Advanced Settings
   -  Set "Enable 32-bit Applications" to False

Standard 500 error page is returned instead of Lasso's default error page.
   IIS's "HTTP Errors" feature may be enabled. To disable:

   Windows 2008
      -  Open 'Server Manager'
      -  Select 'Roles' node
      -  Scroll to 'Web Server'
      -  Click 'Remove Role Services'
      -  Expand 'Web Server -> Common HTTP Features'
      -  Uncheck 'HTTP Errors'
      -  Continue through installation wizard

   Windows 2007
      -  Open 'Control Panel'
      -  Click 'Programs'
      -  Click 'Turn Windows features on or off'
      -  Expand 'Internet Information Services -> World Wide Web Services ->
         Common HTTP Features'
      -  Uncheck 'HTTP Errors'
      -  Continue through installation wizard


LassoTube How Tos
=================

`Configure Apache2 and Lasso
<http://www.youtube.com/watch?v=f7oCiUw-OxA&list=UUVvBq5EMVi4KoME3rvNOgOA&index=2&feature=plcp>`_

`Configure IIS7 for Lasso
<http://www.youtube.com/watch?v=oQ-6K3EHY3M&feature=relmfu>`_